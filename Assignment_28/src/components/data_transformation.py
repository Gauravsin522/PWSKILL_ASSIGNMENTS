import sys
from dataclasses import dataclass

import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

from src.exception import CustomException
from src.logger import logging
import os

from src.utils import save_object

@dataclass
class DataTransformationConfig:
    preprocessor_obj_file_path: str = os.path.join('artifacts', 'preprocessor.pkl')
    transformed_train_file_path: str = os.path.join('artifacts', 'train.npy')
    transformed_test_file_path: str = os.path.join('artifacts', 'test.npy')

class DataTransformation:
    def __init__(self):
        self.config = DataTransformationConfig()

    def _add_engineered_features(self, df: pd.DataFrame) -> pd.DataFrame:
        # Engineered features
        df['Volatility'] = df[['1h', '24h', '7d']].std(axis=1)
        df['Liquidity Index'] = df['24h_volume'] / df['mkt_cap']
        return df

    def get_data_transformer_object(self, df: pd.DataFrame) -> ColumnTransformer:
        try:
            # Define potential feature lists
            predefined_num = ['1h', '24h', '7d', '24h_volume', 'mkt_cap', 'Volatility', 'Liquidity Index']
            predefined_cat = ['name', 'symbol']

            # Select only those present in dataframe
            numerical_columns = [col for col in predefined_num if col in df.columns]
            categorical_columns = [col for col in predefined_cat if col in df.columns]

            logging.info(f"Using numerical columns: {numerical_columns}")
            logging.info(f"Using categorical columns: {categorical_columns}")

            # Pipelines
            num_pipeline = Pipeline([
                ('imputer', SimpleImputer(strategy='mean')),
                ('scaler', StandardScaler())
            ])
            cat_pipeline = Pipeline([
                ('imputer', SimpleImputer(strategy='most_frequent')),
                ('onehot', OneHotEncoder(handle_unknown='ignore'))
            ])

            transformers = []
            if numerical_columns:
                transformers.append(('num', num_pipeline, numerical_columns))
            if categorical_columns:
                transformers.append(('cat', cat_pipeline, categorical_columns))

            if not transformers:
                raise CustomException("No valid features found for transformation", sys)

            # Always output dense array
            preprocessor = ColumnTransformer(
                transformers=transformers,
                sparse_threshold=1.0
            )
            return preprocessor
        except Exception as e:
            logging.error(f"Error in get_data_transformer_object: {e}")
            raise CustomException(e, sys)

    def initiate_data_transformation(self, train_path: str, test_path: str):
        try:
            # Load data
            train_df = pd.read_csv(train_path)
            test_df = pd.read_csv(test_path)
            logging.info("Loaded train and test data")

            # Engineer features
            train_df = self._add_engineered_features(train_df)
            test_df = self._add_engineered_features(test_df)

            # Drop rows with missing target
            target_col = 'Liquidity Index'
            train_df = train_df.dropna(subset=[target_col]).reset_index(drop=True)
            test_df = test_df.dropna(subset=[target_col]).reset_index(drop=True)

            # Separate features and target
            if target_col not in train_df.columns or target_col not in test_df.columns:
                raise CustomException(f"Target column '{target_col}' missing in dataframes", sys)

            X_train = train_df.drop(columns=[target_col])
            y_train = train_df[target_col]
            X_test = test_df.drop(columns=[target_col])
            y_test = test_df[target_col]

            # Build preprocessor based on training features
            preprocessor = self.get_data_transformer_object(X_train)
            logging.info("Fitting preprocessor on training data")
            X_train_transformed = preprocessor.fit_transform(X_train)
            X_test_transformed = preprocessor.transform(X_test)

            # Ensure X arrays are 2D
            if X_train_transformed.ndim == 1:
                X_train_transformed = X_train_transformed.reshape(-1, 1)
            if X_test_transformed.ndim == 1:
                X_test_transformed = X_test_transformed.reshape(-1, 1)

            # Convert target to column vectors
            y_train_arr = np.array(y_train).reshape(-1, 1)
            y_test_arr = np.array(y_test).reshape(-1, 1)

            # Check for shape consistency
            if X_train_transformed.shape[0] != y_train_arr.shape[0]:
                raise CustomException(
                    f"Train data mismatch: features rows={X_train_transformed.shape[0]} vs target rows={y_train_arr.shape[0]}",
                    sys
                )
            if X_test_transformed.shape[0] != y_test_arr.shape[0]:
                raise CustomException(
                    f"Test data mismatch: features rows={X_test_transformed.shape[0]} vs target rows={y_test_arr.shape[0]}",
                    sys
                )

            # Combine features and target
            train_arr = np.hstack([X_train_transformed, y_train_arr])
            test_arr = np.hstack([X_test_transformed, y_test_arr])

            # Save preprocessor
            save_object(self.config.preprocessor_obj_file_path, preprocessor)
            logging.info(f"Preprocessor saved at {self.config.preprocessor_obj_file_path}")

            return train_arr, test_arr, self.config.preprocessor_obj_file_path
        except Exception as e:
            logging.error(f"Error during data transformation: {e}")
            raise CustomException(e, sys)
