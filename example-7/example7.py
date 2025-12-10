# 1. Import necessary libraries
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score

# 2. Load the dataset
iris = load_iris()
X = iris.data  # Features (sepal length, sepal width, petal length, petal width)
y = iris.target # Target (species: setosa, versicolor, virginica)

# 3. Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# 4. Create and train a machine learning model (Decision Tree Classifier)
model = DecisionTreeClassifier()
model.fit(X_train, y_train)

# 5. Make predictions on the test set
y_pred = model.predict(X_test)

# 6. Evaluate the model's performance
accuracy = accuracy_score(y_test, y_pred)
print(f"Model Accuracy: {accuracy:.2f}")

# Optional: Predict on a new, unseen data point
new_flower = [[5.1, 3.5, 1.4, 0.2]] # Example measurements
predicted_species = model.predict(new_flower)
print(f"Predicted species for new flower: {iris.target_names[predicted_species[0]]}")
