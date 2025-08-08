import os
import sys
import pandas as pd
from src.exception import CustomException
from src.utils import load_object

class PredictPipeline:
    def __init__(self):
        pass

    def predict(self, features):
        try:
            model_path = os.path.join("artifacts", "cat_model.pkl")
            preprocessor_path = os.path.join("artifacts", "preprocessor.pkl")

            print("Before Loading Artifacts")
            model = load_object(file_path=model_path)
            preprocessor = load_object(file_path=preprocessor_path)
            print("After Loading Artifacts")

            data_scaled = preprocessor.transform(features)
            preds = model.predict(data_scaled)
            return preds

        except Exception as e:
            raise CustomException(e, sys)
        
# Define the CustomData class
class CustomData:
    def __init__(self, price, volume, market_cap):
        self.price = price
        self.volume = volume
        self.market_cap = market_cap

    def get_data_as_data_frame(self):
        import pandas as pd
        return pd.DataFrame({
            'price': [self.price],
            'volume': [self.volume],
            'market_cap': [self.market_cap]
        })

