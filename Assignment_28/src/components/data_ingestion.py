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
        # Create volatility and liquidity index
        df['Volatility'] = df[['1h', '24h', '7d']].std(axis=1)
        df['Liquidity Index'] = df['24h_volume'] / df['mkt_cap']
        return df

    def get_data_transformer_object(self, df: pd.DataFrame) -> ColumnTransformer:
        try:
            # Candidate features
            num_feats = ['1h', '24h', '7d', '24h_volume', 'mkt_cap', 'Volatility', 'Liquidity Index']
            cat_feats = ['name', 'symbol']

            num_cols = [c for c in num_feats if c in df.columns]
            cat_cols = [c for c in cat_feats if c in df.columns]

            logging.info(f"Numerical: {num_cols}, Categorical: {cat_cols}")

            num_pipe = Pipeline([
                ('imputer', SimpleImputer(strategy='mean')),
                ('scale', StandardScaler())
            ])
            cat_pipe = Pipeline([
                ('imputer', SimpleImputer(strategy='most_frequent')),
                ('onehot', OneHotEncoder(handle_unknown='ignore'))
            ])

            transformers = []
            if num_cols:
                transformers.append(('num', num_pipe, num_cols))
            if cat_cols:
                transformers.append(('cat', cat_pipe, cat_cols))

            if not transformers:
                raise CustomException("No features found", sys)

            return ColumnTransformer(transformers=transformers, sparse_threshold=1.0)
        except Exception as ex:
            logging.error(f"Transformer init error: {ex}")
            raise CustomException(ex, sys)

    def initiate_data_transformation(self, train_path: str, test_path: str):
        try:
            # Load
            train_df = pd.read_csv(train_path)
            test_df = pd.read_csv(test_path)

            # Feature engineering
            train_df = self._add_engineered_features(train_df)
            test_df = self._add_engineered_features(test_df)

            # Drop missing targets
            tgt = 'Liquidity Index'
            train_df = train_df.dropna(subset=[tgt]).reset_index(drop=True)
            test_df = test_df.dropna(subset=[tgt]).reset_index(drop=True)

            # Split
            X_train = train_df.drop(columns=[tgt])
            y_train = train_df[tgt]
            X_test = test_df.drop(columns=[tgt])
            y_test = test_df[tgt]

            # Transform
            preprocessor = self.get_data_transformer_object(X_train)
            X_train_t = preprocessor.fit_transform(X_train)
            X_test_t = preprocessor.transform(X_test)

            # Force numpy arrays
            X_train_arr = np.asarray(X_train_t)
            X_test_arr = np.asarray(X_test_t)

            # Ensure 2D
            if X_train_arr.ndim == 1:
                X_train_arr = X_train_arr.reshape(-1,1)
            if X_test_arr.ndim == 1:
                X_test_arr = X_test_arr.reshape(-1,1)

            # Targets
            y_train_arr = np.asarray(y_train).reshape(-1,1)
            y_test_arr = np.asarray(y_test).reshape(-1,1)

            # Validate shapes
            if X_train_arr.shape[0] != y_train_arr.shape[0] or X_test_arr.shape[0] != y_test_arr.shape[0]:
                raise CustomException(f"Row mismatch: X_train {X_train_arr.shape[0]} vs y_train {y_train_arr.shape[0]}", sys)

            # Concatenate
            train_arr = np.concatenate([X_train_arr, y_train_arr], axis=1)
            test_arr = np.concatenate([X_test_arr, y_test_arr], axis=1)

            # Save
            save_object(self.config.preprocessor_obj_file_path, preprocessor)
            return train_arr, test_arr, self.config.preprocessor_obj_file_path
        except Exception as ex:
            logging.error(f"Data transform error: {ex}")
            raise CustomException(ex, sys)
