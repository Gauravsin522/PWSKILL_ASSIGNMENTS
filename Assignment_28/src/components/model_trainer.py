import os 
import sys
from dataclasses import dataclass

from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor, AdaBoostRegressor, GradientBoostingRegressor
from sklearn.neighbors import KNeighborsRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.svm import SVR
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
from sklearn.ensemble import AdaBoostRegressor
from xgboost import XGBRegressor
from catboost import CatBoostRegressor # type: ignore
from sklearn import metrics 

from src.exception import CustomException
from src.logger import logging

from src.utils import save_object,evaluate_models

@dataclass
class ModelTrainerConfig:
    trained_model_file_path = os.path.join('artifacts', 'model.pkl')
    # trained_model_file_path = os.path.join('artifacts', 'model.pkl')
    
class ModelTrainer:
    def __init__(self):
        self.model_trainer_config = ModelTrainerConfig()
        
    def initiate_model_trainer(self, train_array, test_array):  
        try:
            logging.info("Splitting training and test data")
            X_train, y_train, X_test, y_test = (
                train_array[:, :-1],
                train_array[:, -1],
                test_array[:, :-1],
                test_array[:, -1],
            )
            
            models = {
                "Linear Regression": LinearRegression(),
                "Random Forest": RandomForestRegressor(),
                "Decision Tree": DecisionTreeRegressor(),
                "KNeighbors": KNeighborsRegressor(),
                "SVR": SVR(),
                "AdaBoost": AdaBoostRegressor(),
                "XGBoost": XGBRegressor(),
                "CatBoost": CatBoostRegressor(verbose=0),
            }
            
            params = {
                "Linear Regression": {},
                "Random Forest": {
                    "n_estimators": 100,
                    "max_depth": 10,
                    "min_samples_split": 2,
                },
                "Decision Tree": {
                    "max_depth": 10,
                    "min_samples_split": 2,
                },
                "KNeighbors": {"n_neighbors": 5},
                "SVR": {"kernel": "rbf"},
                "AdaBoost": {"n_estimators": 100},
                "XGBoost": {"n_estimators": 100, "learning_rate": 0.1},
                "CatBoost": {"iterations": 100, "depth": 6, "learning_rate": 0.1},
            
            }       
            
            model_report: dict = evaluate_models(X_train = X_train, y_train = y_train, X_test = X_test, y_test = y_test, models = models, params = params)
            
            best_model_score = max(sorted(model_report.values()))
            best_model_name = list(model_report.keys())[
                list(model_report.values()).index(best_model_score)
            ]
            
            best_model = models[best_model_name]
            
            if best_model_score < 0.6:
                raise CustomException("No best model found")
            logging.info("Best model found on both training and testing data")
            
            save_object(
                file_path=self.model_trainer_config.trained_model_file_path,
                obj=best_model,
            )
            
            predicted = best_model.predict(X_test)
            
            r2_square = r2_score(y_test, predicted)
            mean_absolute = mean_absolute_error(y_test, predicted)
            mean_squared = mean_squared_error(y_test, predicted)
            
            return r2_square, mean_absolute, mean_squared, best_model_name
        
        except Exception as e:
            logging.error(f"Error occurred during model training: {e}")
            raise CustomException(e, sys)