class Matrix {
  int cols;
  int rows;
  float[][] matrix;


  Matrix(int rows, int cols, float[][] matrix) {
    this.cols = cols;
    this.rows = rows;
    if (matrix == null) {
      initMatrix();
    } else {
      this.matrix = matrix;
    }
  }


  void initMatrix() {
    matrix = new float[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] = 0;
      }
    }
  }


  Matrix transpose() {
    int rows = matrix.length;
    int cols = matrix[0].length;
    float[][] arr = new float[cols][rows];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        arr[j][i] = matrix[i][j];
      }
    }
    return new Matrix(cols, rows, arr);
  }

  Matrix subtract(Matrix a) {
    if (a.rows != this.rows || a.cols != this.cols) {
      return null;
    }
    float[][] arr = new float[a.rows][this.cols];
    for (int i = 0; i < a.rows; i++) {
      for (int j = 0; j < a.cols; j++) {
        arr[i][j] = this.matrix[i][j] - a.matrix[i][j];
      }
    }
    return new Matrix(a.rows, this.cols, arr);
  }

  void add(float n) {
    int rows = matrix.length;
    int cols = matrix[0].length;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] += n;
      }
    }
  }

  float[][] copyMatrix() {
    float[][] arr = new float[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        arr[i][j] = matrix[i][j];
      }
    }
    return arr;
  }

  void add(Matrix n) {
    if (rows != n.rows || cols != n.cols) {
      return;
    }
    int rows = matrix.length;
    int cols = matrix[0].length;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] += n.matrix[i][j];
      }
    }
  }

  void multiply(float n) {
    int rows = matrix.length;
    int cols = matrix[0].length;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] *= n;
      }
    }
  }

  void multiply(Matrix n) {
    if (cols != n.rows) {
      return;
    }
    int rows = this.rows;
    int cols = n.cols;
    float[][] arr = matrix;
    matrix = new float[rows][cols];
    this.cols = cols;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        for (int k = 0; k < arr[0].length; k++) {
          matrix[i][j] += arr[i][k] * n.matrix[k][j];
        }
      }
    }
  }

  Matrix multiplyR(Matrix n) {
    if (cols != n.rows) {
      return null;
    }
    int rows = this.rows;
    int cols = n.cols;
    float[][] arr = new float[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        for (int k = 0; k < matrix[0].length; k++) {
          arr[i][j] += matrix[i][k] * n.matrix[k][j];
        }
      }
    }
    return new Matrix(rows, cols, arr);
  }

  // Hadamard product
  void multiply(Matrix n, boolean hadamard) {
    if (cols == n.cols && rows == n.rows && hadamard) {
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          matrix[i][j] *= n.matrix[i][j];
        }
      }
    } else {
      return;
    }
  }


  void randomize() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        matrix[i][j] = random(-1, 1);
      }
    }
  }

  void printMatrix() {
    for (int i = 0; i < this.rows; i++) {
      for (int j = 0; j < this.cols; j++) {
        print(this.matrix[i][j] + " ");
      }
      println("");
    }
  }
}
