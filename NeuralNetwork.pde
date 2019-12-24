float sigmoid(float x) {
  double d = x;
  return (float)(1 / (1 + Math.exp(-d)));
}

float dsigmoid(float x) {
  return (x * (1 - x));
}

class NeuralNetwork {
  int input_nodes;
  int hidden_nodes;
  int output_nodes;
  float learningRate = 0.1;

  Matrix weights_ih;
  Matrix weights_ho;
  Matrix bias_h;
  Matrix bias_o;

  NeuralNetwork(int input_nodes, int hidden_nodes, int output_nodes) {
    this.input_nodes = input_nodes;
    this.output_nodes = output_nodes;
    this.hidden_nodes = hidden_nodes;
    initMatrices();
  }


  void initMatrices() {
    weights_ih = new Matrix(hidden_nodes, input_nodes, null);
    weights_ho = new Matrix(output_nodes, hidden_nodes, null);
    bias_h = new Matrix(hidden_nodes, 1, null);
    bias_o = new Matrix(output_nodes, 1, null);
    weights_ih.randomize();
    weights_ho.randomize();
    bias_h.randomize();
    bias_o.randomize();
  }


  // Trained model should get fairly correct outputs from this method
  float[] feedForward(float[] inputs) {    

    // Generate the hidden outputs
    Matrix inputMatrix = createMatrix(inputs);
    Matrix hiddenM = weights_ih.multiplyR(inputMatrix);
    hiddenM.add(bias_h);

    // Activation function
    activateMatrix(hiddenM);

    // Generating outputs
    Matrix outputM = weights_ho.multiplyR(hiddenM);
    outputM.add(bias_o);
    activateMatrix(outputM);

    //Activation function for outputs
    float[] arr = createArray(outputM);

    return arr;
  }


  // Train method uses this method to fine tune weights
  void backPropagate() {
  }

  // Feed forward once and calculate how off is our answer.
  void trainOnce(float[] input, float[] target) {

    // Generate the hidden outputs
    Matrix inputMatrix = createMatrix(input);
    Matrix hiddenM = weights_ih.multiplyR(inputMatrix);
    hiddenM.add(bias_h);

    // Activation function
    activateMatrix(hiddenM);

    // Generating outputs
    Matrix outputM = weights_ho.multiplyR(hiddenM);
    outputM.add(bias_o);
    activateMatrix(outputM);

    // Convert to matrices for calculations
    Matrix targetMatrix = createMatrix(target);


    // Calculate output error matrix
    Matrix output_errors = targetMatrix.subtract(outputM);

    // Calculate hidden layer errors
    Matrix weights_ho_t = weights_ho.transpose();
    Matrix hidden_errors = weights_ho_t.multiplyR(output_errors);

    // Calculate output gradients
    Matrix output_gradient = calculateDsigmoid(outputM);
    output_gradient.multiply(output_errors,true);
    output_gradient.multiply(learningRate);


    Matrix hidden_T = hiddenM.transpose();
    Matrix weights_ho_deltas = output_gradient.multiplyR(hidden_T);


    //Adjust weights
    weights_ho.add(weights_ho_deltas);
    bias_o.add(output_gradient);

    // Calculate hidden gradients
    Matrix hidden_gradient = calculateDsigmoid(hiddenM);
    hidden_gradient.multiply(hidden_errors, true);
    hidden_gradient.multiply(learningRate);

    Matrix input_T = inputMatrix.transpose();
    Matrix weights_ih_deltas = hidden_gradient.multiplyR(input_T);
    
    weights_ih.add(weights_ih_deltas);
    bias_h.add(hidden_gradient);
  }



  Matrix createMatrix(float[] arr) {
    float[][] a = new float[arr.length][1];
    for (int i = 0; i < a.length; i++) {
      a[i][0] = arr[i];
    }
    return new Matrix(arr.length, 1, a);
  }


  float[] createArray(Matrix m) {
    float[] a = new float[output_nodes];
    for (int i = 0; i < m.rows; i++) {
      for (int j = 0; j < m.cols; j++) {
        a[i+j] = m.matrix[i][j];
      }
    }
    return a;
  }

  // Push the matrix through activation function
  void activateMatrix(Matrix m) {
    for (int i = 0; i < m.rows; i++) {
      for (int j = 0; j < m.cols; j++) {
        m.matrix[i][j] = sigmoid(m.matrix[i][j]);
      }
    }
  }
  Matrix calculateDsigmoid(Matrix m) {
    float[][] arr = new float[m.rows][m.cols];
    for (int i = 0; i < m.rows; i++) {
      for (int j = 0; j < m.cols; j++) {
        arr[i][j] = dsigmoid(m.matrix[i][j]);
      }
    }
    return new Matrix(m.rows, m.cols, arr);
  }
}
