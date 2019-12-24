class Game {
  Snake snake;
  Food food;
  Tetris tetris;
  NeuralNetwork brain;

  float[] inputs = new float[10];
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
  
  int score = 0;
  float fitness = 0.0;


  boolean over = false;


  Game(int cols, int rows, int cellSize, int xOrder, int yOrder) {
    this.cols = cols;
    this.rows = rows;
    this.xOrder = xOrder;
    this.yOrder = yOrder;
    this.cellSize = cellSize;
    brain = new NeuralNetwork(10, 24, 4);
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
          //println(snake.snake[0].x + " " + -x + " " + snake.snake[0].y + " " + -y);
          if(snake.snake[0].x == x && snake.snake[0].y == y){
            over = true;
          }
        }
      }
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
  void update() {
    if (!over) {
      if (!tetris.pieceFalling) {
        decide();
        snake.update();
        food.show();
        if (foodFound()) {
          food.eaten = true;
          createTetrisObject();
          createFood();
          createSnake();
        }
        createInputs();
      }
      checkDead();
      show();
      tetris.update();
    }
  }

  void decide() {
    outputs = brain.feedForward(inputs);
    move();
  }

  void createInputs() {
    // TODO : 
    // Normalize all inputs!!!
    inputs[0] = (food.x - xOrder * cols) / cols;  // cellSize * (food.x - xOrder * cols) / (cols * cellSize) 
    inputs[1] = (food.y - yOrder * rows) / rows;  // cellSize a gerek var mı? yok gibi.
    inputs[2] = snake.snake[0].x;
    inputs[3] = snake.snake[0].y;
    inputs[4] = snake.snake[1].x;
    inputs[5] = snake.snake[1].y;
    inputs[6] = snake.snake[2].x;
    inputs[7] = snake.snake[2].y;
    inputs[8] = snake.snake[3].x;
    inputs[9] = snake.snake[3].y;
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
