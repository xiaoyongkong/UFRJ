# -*- coding: utf-8 -*-
"""Arvore de Decisao - Kaggle

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/13gl67mAkauGOvaruMC7tRosr9KtZvGUy

# Árvore de Decisão - Diabetes

Alunos:

Breno Pontes da Costa - 114036496

Xiao Yong Kong - 114176987
"""

import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn import metrics #Importa métrica para calcular acurácia - módulo do scikit-learn
from sklearn.model_selection import train_test_split
from sklearn.model_selection import KFold
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import cross_validate
from sklearn.tree import export_graphviz
from sklearn.externals.six import StringIO  
from IPython.display import Image  
import pydotplus

# carregando o drive
from google.colab import drive
drive.mount('/content/drive')

# carregando a base de dados a ser usada
diabetes = pd.read_csv("/content/drive/My Drive/IA/diabetes.csv")
diabetes.count()

Xone_hot_data = pd.get_dummies(X_diabetes[['Pregnancies', 'Glucose', 'BloodPressure', 'SkinThickness', 'Insulin', 'BMI', 'DiabetesPedigreeFunction', 'Age']]) #transformando o dataset
Xone_hot_data.head()

# definir o conceito alvo e as features usadas

feature_cols_diabetes = ['Pregnancies', 'Glucose', 'BloodPressure', 'SkinThickness', 'Insulin', 'BMI', 'DiabetesPedigreeFunction', 'Age']
X_diabetes = diabetes[feature_cols_diabetes] # selecionamos as colunas correspondentes aos atributos que serão usados
y_diabetes = diabetes.Outcome # Selecionamos a coluna com a classificação das instâncias

# Usando kfold 2

cv = KFold(n_splits=2, random_state=1, shuffle=True)
model = DecisionTreeClassifier(criterion='entropy')
scores = cross_validate(model, Xone_hot_data, y_diabetes, scoring=['accuracy'], return_train_score=True, cv=cv)
print('Accuracy Test: %.3f (%.3f)' % (scores['test_accuracy'].mean(), scores['test_accuracy'].std()))
print('Accuracy Train: %.3f (%.3f)' % (scores['train_accuracy'].mean(), scores['train_accuracy'].std()))

# Usando kfold 5

cv = KFold(n_splits=5, random_state=1, shuffle=True)
model = DecisionTreeClassifier(criterion='entropy')
scores = cross_validate(model, Xone_hot_data, y_diabetes, scoring=['accuracy'], return_train_score=True, cv=cv)
print('Accuracy Test: %.3f (%.3f)' % (scores['test_accuracy'].mean(), scores['test_accuracy'].std()))
print('Accuracy Train: %.3f (%.3f)' % (scores['train_accuracy'].mean(), scores['train_accuracy'].std()))

# Usando kfold 10

cv = KFold(n_splits=10, random_state=1, shuffle=True)
model = DecisionTreeClassifier(criterion='entropy')
scores = cross_validate(model, Xone_hot_data, y_diabetes, scoring=['accuracy'], return_train_score=True, cv=cv)
print('Accuracy Test: %.3f (%.3f)' % (scores['test_accuracy'].mean(), scores['test_accuracy'].std()))
print('Accuracy Train: %.3f (%.3f)' % (scores['train_accuracy'].mean(), scores['train_accuracy'].std()))

"""Gerando a árvore de decisão

"""

def classifier(X_train, y_train, criteria):
  clf = DecisionTreeClassifier(criterion=criteria)

  # Usamos o método fit para construir o classificador a partir do nosso conjunto de treinamento
  clf = clf.fit(X_train, y_train)
  return clf

def generate_tree(clf, feature_names=X_diabetes.columns):
  # tem que usar feature_names = one_hot_data.columns pois feature_names = feature_cols tem menos atributos
  dot_data = StringIO()
  export_graphviz(clf, out_file=dot_data,  
                  filled=True, rounded=True,
                  special_characters=True,feature_names=feature_names,class_names=['No','Yes'])
  graph = pydotplus.graph_from_dot_data(dot_data.getvalue())  
  return graph

criteria = "entropy"
clf_diabetes = classifier(X_diabetes, y_diabetes, criteria)
graph_diabetes = generate_tree(clf_diabetes, X_diabetes.columns)

graph_diabetes.write_png('arvore-diabetes.png')
Image(graph_diabetes.create_png())

"""Testando a acurácia do classificador gerado"""

X_train_80_diabetes, X_test_80_diabetes, y_train_80_diabetes, y_test_80_diabetes = train_test_split(X_diabetes, y_diabetes, test_size=0.20, random_state=1)
criteria = "entropy"
clf_entropy_80_diabetes = classifier(X_train_80_diabetes, y_train_80_diabetes, criteria)
graph_entropy_80_diabetes = generate_tree(clf_entropy_80_diabetes, X_train_80_diabetes.columns)

graph_entropy_80_diabetes.write_png('arvore-80-diabetes.png')
Image(graph_entropy_80_diabetes.create_png())

def prediction_accuracy(clf, X_test, y_test):
  # Usando modelo para classificar os dados que temos a disposição
  y_pred = clf.predict(X_test)

  # Medida de acuracia, que indica quantas instâncias são corretamente classificadas
  return metrics.accuracy_score(y_test, y_pred)

X_train_60_diabetes, X_test_60_diabetes, y_train_60_diabetes, y_test_60_diabetes = train_test_split(X_diabetes, y_diabetes, test_size=0.20, random_state=1)
criteria = "entropy"
clf_entropy_60_diabetes = classifier(X_train_60_diabetes, y_train_60_diabetes, criteria)

prediction_test_diabetes = prediction_accuracy(clf_entropy_60_diabetes, X_test_60_diabetes, y_test_60_diabetes)
print('Acurácia teste: ', prediction_test_diabetes)

prediction_test_diabetes = prediction_accuracy(clf_entropy_80_diabetes, X_test_80_diabetes, y_test_80_diabetes)
print('Acurácia teste: ', prediction_test_diabetes)

prediction_train_diabetes = prediction_accuracy(clf_diabetes, X_diabetes, y_diabetes)
print('Acurácia teste: ', prediction_train_diabetes)