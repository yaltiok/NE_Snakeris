
final int cellSize = 5;
final int colCount = 11;
final int rowCount = 20;
final int xCount = 10;
final int yCount = 6;
final int gameCount = xCount * yCount;
final int w = cellSize * colCount * xCount;
final int h = cellSize * rowCount * yCount;

final int lifeTime = 200;
int cycle = 0;
GeneticAlgorithm ga;

Game[][] games = new Game[xCount][yCount];


void settings() {
  size(w, h);
}


void setup() {
  //frameRate(8);

  noFill();
  for (int i = 0; i< xCount; i++) {
    for (int j = 0; j < yCount; j++) {
      games[i][j] = new Game(colCount, rowCount, cellSize, i, j);
    }
  }
  ga = new GeneticAlgorithm(games);
}

void draw() {
  background(52);
  if (cycle >= lifeTime) {
    startNewGame();
  }
  for (int i = 0; i< xCount; i++) {
    for (int j = 0; j< yCount; j++) {
      games[i][j].update();
    }
  }
  push();
  strokeWeight(1/gameCount);
  stroke(255);
  for (int i = 1; i < xCount; i++) {
    line(i * colCount * cellSize, 0, i * colCount * cellSize, height);
  }
  for (int i = 1; i < yCount; i++) {
    line(0, i * rowCount * cellSize, width, i * rowCount * cellSize);
  }
  pop();
  cycle++;
}

void mousePressed() {
  for (int i = 0; i< xCount; i++) {
    for (int j = 0; j < yCount; j++) {
      games[i][j].createFood();
    }
  }
}


void startNewGame() {
  //for (int i = 0; i< xCount; i++) {
  //  for (int j = 0; j < yCount; j++) {
  //    games[i][j] = new Game(colCount, rowCount, cellSize, i, j);
  //  }
  //}
  //cycle = 0;
  ga.nextGeneration();
  cycle = 0;
}

//void keyPressed() {
//  for (int i = 0; i< xCount; i++) {
//    for (int j = 0; j < yCount; j++) {
//      Game game = games[i][j];
//      if (key == CODED) {

//      }
//    }
//  }
//}
