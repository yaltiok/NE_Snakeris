// TODO:
// 1) Spawn food accordingly!


class Game {
  Snake snake;
  Food food;
  Tetris tetris;
  NeuralNetwork brain;

  float[] inputs = new float[452];
  float[] outputs = new float[4];

  int cols;
  int rows;
  int cellSize;
  int xOrder;
  int yOrder;
  int xStartPoint;
  int xEndPoint;
  int yStartPoint;
  int yEndPoint;

  float score = 100;
  float fitness = 0.0;


  boolean over = false;


  Game(int cols, int rows, int cellSize, int xOrder, int yOrder) {
    this.cols = cols;
    this.rows = rows;
    this.xOrder = xOrder;
    this.yOrder = yOrder;
    this.cellSize = cellSize;
    brain = new NeuralNetwork(inputs.length, 512, 4);
    xStartPoint = xOrder * cols;
    xEndPoint = (xOrder + 1) * cols;
    yStartPoint = yOrder * rows;
    yEndPoint = (yOrder + 1) * rows;
    createFood();
    createSnake();
    initTetris();
  }

  void checkDead() {
    if (snake.dead) {
      over = true;
    }
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (tetris.droppedPieces[i][j]) {
          float x = cellSize*(i + (xOrder) * cols);
          float y = cellSize*(j + (yOrder) * rows);
          if (snake.snake[0].x == x && snake.snake[0].y == y) {
            over = true;
          }
        }
      }
    }
    if (over) {
      score-=100;
    }
  }

  void setSnakeDir(int dirX, int dirY) {
    snake.dirX = dirX;
    snake.dirY = dirY;
  }


  void initTetris() {
    tetris = new Tetris(cols, rows, xOrder, yOrder, cellSize);
  }

  boolean foodFound() {
    return (dist(snake.snake[0].x, snake.snake[0].y, food.x * cellSize, food.y * cellSize) < cellSize);
  }

  void createSnake() {
    snake = new Snake(xStartPoint * cellSize, xEndPoint * cellSize, yStartPoint * cellSize, yEndPoint * cellSize, cellSize);
  }

  void createTetrisObject() {
    tetris.setSnakeLocation(snake);
    tetris.pieceFalling = true;
  }



  void createFood() {
    food = new Food(cellSize);
  }

  void show() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        rect(i * cellSize + xStartPoint * cellSize, j * cellSize + yStartPoint * cellSize, cellSize, cellSize);
      }
    }
  }
  void update(boolean show) {
    if (!over) {
      score++;
      if (!tetris.pieceFalling) {
        decide();
        snake.update(show);
        if (foodFound()) {
          score+=100;
          food.eaten = true;
          createTetrisObject();
          createFood();
          createSnake();
        }
        createInputs();
      }
      checkDead();
      if (show) {
        food.show();
        show();
      }
      tetris.update(show);
    }
  }

  void decide() {
    outputs = brain.feedForward(inputs);
    move();
  }

  void createInputs() {
    // TODO : 
    // Normalize all inputs!!!
    float offsetX = (cellSize * xOrder * cols);
    float offsetY = (cellSize * yOrder * rows);
    float xDenominator = (cols*cellSize);
    float yDenominator = (rows*cellSize);
    inputs[0] = (food.x - xOrder * cols) / cols;  // cellSize * (food.x - xOrder * cols) / (cols * cellSize) 
    inputs[1] = (food.y - yOrder * rows) / rows;  // cellSize a gerek var mı? yok gibi.

    inputs[2] = (snake.snake[0].x - offsetX) / (xDenominator);
    inputs[4] = (snake.snake[1].x - offsetX) / (xDenominator);
    inputs[6] = (snake.snake[2].x - offsetX) / (xDenominator);
    inputs[8] = (snake.snake[3].x - offsetX) / (xDenominator);

    inputs[3] = (snake.snake[0].y - offsetY) / (yDenominator);
    inputs[5] = (snake.snake[1].y - offsetY) / (yDenominator);
    inputs[7] = (snake.snake[2].y - offsetY) / (yDenominator);
    inputs[9] = (snake.snake[3].y - offsetY) / (yDenominator);

    for (int i = rows - 1; i >= 6; i--) {
      for (int j = cols - 1; j >= 0; j--) {
        boolean filled = tetris.droppedPieces[j][i];
        int index = (3 * i) + 10;
        float x = i / cols;
        float y = j / rows;
        inputs[index] = x;
        inputs[index + 1] = y;
        if (filled) {
          inputs[index + 2] = 1;
        } else {
          inputs[index + 2] = 0;
        }
      }
    }
  }
  void move() {
    int dirX = snake.dirX;
    int dirY = snake.dirY;
    int idx = biggest(outputs);
    if (idx == 0 && dirY == 0) { // UP
      dirY = 1;
      dirX = 0;
    } else if (idx == 2 && dirY == 0) { // DOWN
      dirY = -1;
      dirX = 0;
    } else if (idx == 3 && dirX == 0) { // LEFT
      dirX = -1;
      dirY = 0;
    } else if (idx == 1 && dirX == 0) { // RIGHT
      dirX = 1;
      dirY = 0;
    }
    setSnakeDir(dirX, dirY);
  }

  int biggest(float[] arr) {
    float biggest = -10;
    int idx = -1;
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] > biggest) {
        biggest = arr[i];
        idx = i;
      }
    }
    return idx;
  }

  class Food {
    int x = floor(random(xStartPoint, xEndPoint));
    //int x = 6 + xStartPoint;
    int y = 5 + yStartPoint;
    boolean eaten = false;
    int size;
    Food(int size) {
      this.size = size;
    }

    void show() {
      if (!eaten) {
        push();
        fill(255);
        rect(x * size, y * size, size, size);
        pop();
      }
    }
  }
}
