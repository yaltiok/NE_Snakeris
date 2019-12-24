// TODO :
// 1) Figure out a way to do crossover (NN needs a copy function!)
// 2) Mutation
// 3) Repopulation





class GeneticAlgorithm {
  Game[][] games;
  GeneticAlgorithm(Game[][] games) {
    this.games = games;
  }


  void nextGeneration() {
    calculateFitness();
    for (int i = 0; i< xCount; i++) {
      for (int j = 0; j < yCount; j++) {
        games[i][j] = new Game(colCount, rowCount, cellSize, i, j);
      }
    }
  }
  
  
  
  void calculateFitness(){
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
  }
}
