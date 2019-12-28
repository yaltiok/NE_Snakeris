
final int cellSize = 2;
final int colCount = 11;
final int rowCount = 20;
final int xCount = 40;
final int yCount = 22;
final int gameCount = xCount * yCount;
final int w = cellSize * colCount * xCount;
final int h = cellSize * rowCount * yCount;
int gamesLeft = gameCount;
int gameSpeed = 1;
boolean fast = false;
boolean show = true;
int generation = 1;

final int lifeTime = 500;
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

  for (int k = 0; k < gameSpeed; k++) {
    if (cycle >= lifeTime || countGames() <= 0) {
      startNewGame();
    }
    for (int i = 0; i< xCount; i++) {
      for (int j = 0; j< yCount; j++) {
        games[i][j].update(show);
      }
    }
    cycle++;
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
}

void mousePressed() {
  for (int i = 0; i< xCount; i++) {
    for (int j = 0; j < yCount; j++) {
      games[i][j].createFood();
    }
  }
}


void startNewGame() {
  ga.nextGeneration();
  cycle = 0;
  generation++;
  println(generation);
}


int countGames() {
  int sum = 0;
  for (int i = 0; i< xCount; i++) {
    for (int j = 0; j < yCount; j++) {
      if (!games[i][j].over) {
        sum++;
      }
    }
  }
  return sum;
}

void keyPressed() {
  if (keyCode == UP && !fast) {
    gameSpeed=10;
    fast = true;
    println("Game Speed : " + gameSpeed);
  } else if (keyCode == DOWN && fast) {
    gameSpeed=1;
    fast = false;
    println("Game Speed : " + gameSpeed);
  } else if (keyCode == BACKSPACE) {
    if (show) {
      show = false;
    } else {
      show = true;
    }
  } else if (keyCode == ENTER) {
    if (frameRate <= 10) {
      frameRate(60);
    } else {
      frameRate(8);
    }
  } else if (keyCode == RIGHT) {
    startNewGame();
  }
  println("Frame Rate : " + frameRate);
}
