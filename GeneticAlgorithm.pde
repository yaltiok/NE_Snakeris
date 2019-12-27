// TODO :
// 1) Mating Pool needs improvements
// 2) pickOne needs improvements


class GeneticAlgorithm {
  Game[][] games;
  ArrayList<Game> matingPool = new ArrayList();
  float mutationRate = 0.01;

  GeneticAlgorithm(Game[][] games) {
    this.games = games;
  }


  void nextGeneration() {
    calculateFitness();
    fillMatingPool();
    for (int i = 0; i< xCount; i++) {
      for (int j = 0; j < yCount; j++) {
        games[i][j] = reproduce(i, j);
      }
    }
    emptyMatingPool();
  }

  Game reproduce(int i, int j) {

    Game parentA = pickOne();
    Game parentB = pickOne();



    Game child = new Game(colCount, rowCount, cellSize, i, j);

    crossOver(parentA, parentB, child);

    mutate(child);

    return child;
  }


  void crossOver(Game parentA, Game parentB, Game child) {

    float[][] A_inputW = parentA.brain.weights_ih.copyMatrix();
    float[][] A_hiddenW = parentA.brain.weights_ho.copyMatrix();

    float[][] B_inputW = parentB.brain.weights_ih.copyMatrix();
    float[][] B_hiddenW = parentB.brain.weights_ho.copyMatrix();

    child.brain.weights_ih.matrix = mix(A_inputW, B_inputW);
    child.brain.weights_ho.matrix = mix(A_hiddenW, B_hiddenW);
  }

  float[][] mix(float[][] a, float[][] b) {
    int rows = a.length;
    int cols = b[0].length;
    boolean turn = true;
    float[][] arr = new float[rows][cols];
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (turn) {
          arr[i][j] = a[i][j];
          turn = !turn;
        } else {
          arr[i][j] = b[i][j];
          turn = !turn;
        }
      }
    }

    return arr;
  }


  // Changes weight every value with 1 percent probability.
  // Belki yüzde 1 ihtimalle sadece 1 tanesini değiştirmeli?
  void mutate(Game child) {

    float[][] inputM = child.brain.weights_ih.matrix;
    float[][] hiddenM = child.brain.weights_ho.matrix;


    for (int i = 0; i < inputM.length; i++) {
      for (int j = 0; j < inputM[0].length; j++) {
        if (random(1) < mutationRate) {
          inputM[i][j] += randomGaussian();
        }
      }
    }

    for (int i = 0; i < hiddenM.length; i++) {
      for (int j = 0; j < hiddenM[0].length; j++) {
        if (random(1) < mutationRate) {
          hiddenM[i][j] += randomGaussian();
        }
      }
    }
  }

  Game pickOne() {
    int index = 0;
    float r = random(1);

    while (r >= 0) {
      //print(matingPool.size());
      r = r - matingPool.get(index).fitness;
      index++;
    }
    index--;

    //Game g = matingPool.get(index);
    //matingPool.remove(index);
    return matingPool.get(index);
  }


  void calculateFitness() {
    int sum = 0;
    for (int i = 0; i< xCount; i++) {
      for (int j = 0; j < yCount; j++) {
        sum += games[i][j].score;
      }
    }
    for (int i = 0; i< xCount; i++) {
      for (int j = 0; j < yCount; j++) {
        games[i][j].fitness = games[i][j].score / sum;
      }
    }
    //println(sum + " " + games[0][0].fitness + " " +games[1][0].fitness);
  }

  void emptyMatingPool() {
    matingPool.clear();
  }


  void fillMatingPool() {
    for (int i = 0; i< xCount; i++) {
      for (int j = 0; j < yCount; j++) {
        matingPool.add(games[i][j]);
      }
    }
  }
}
