import os
import bentoml
import keras
import tensorflow as tf
from bentoml.io import Image, JSON

RUN_ID = os.environ["RUN_ID"]

model_tag = bentoml.mlflow.import_from_uri(RUN_ID, f'runs:/{RUN_ID}/model')
runner = bentoml.mlflow.load_runner(model_tag)
svc = bentoml.Service(RUN_ID, runners=[runner])

@svc.api(input=Image(), output=JSON())
def classify(input):
    img = tf.image.resize(input, (180, 180))
    img_array = keras.preprocessing.image.img_to_array(img)
    img_array = tf.expand_dims(img_array, 0)
    return runner.run_batch(img_array)
