class Snake {


  int cellSize;

  int hi;
  int hf;
  int wf;
  int wi;
  SnakePiece[] snake = new SnakePiece[4];
  SnakePiece[] lastSnake = new SnakePiece[3];
  int dirX = 0;
  int dirY = -1;

  boolean dead = false;


  Snake(int wi, int wf, int hi, int hf, int cellSize) {
    for (int i = 0; i < 4; i++) {
      snake[i] = new SnakePiece(wi + cellSize * 5, hi + (-i*cellSize) + cellSize);
    }
    this.hi = hi;
    this.hf = hf;
    this.wi = wi;
    this.wf = wf;
    this.cellSize = cellSize;
  }

  void update(boolean show) {
    moveSnake();
    edges();
    if (show) {
      show();
    }
  }


  void moveSnake() {
    for (int i = 0; i < lastSnake.length; i++) {
      lastSnake[i] = new SnakePiece(0, 0);
      lastSnake[i].x = snake[i].x;
      lastSnake[i].y = snake[i].y;
    }
    snake[0].x += dirX*cellSize;
    snake[0].y += dirY*-cellSize;
    for (int i = 0; i < lastSnake.length; i++) {
      snake[i+1] = lastSnake[i];
    }
  }

  void edges() {
    if (snake[0].x >= wf) {
      //snake[0].x = wi;
      dead = true;
    } else if (snake[0].x < wi) {
      //snake[0].x = wf-cellSize;
      dead = true;
    } else if (snake[0].y >= hf) {
      //snake[0].y = hi;
      dead = true;
    } else if (snake[0].y < hi) {
      //snake[0].y = hf-cellSize;
      dead = true;
    }
    //if (snake[0].x >= wf || snake[0].x < wi || snake[0].y >= hf || snake[0].y < hi) {
    //  dead = true;
    //}
  }


  void show() {
    push();
    for (int i = 0; i < 4; i++) {
      fill(255, 0, 0);
      rect(snake[i].x, snake[i].y, cellSize, cellSize);
    }
    pop();
  }
  // Every piece of snake is a SnakePiece Class
  class SnakePiece {
    int x;
    int y;
    SnakePiece(int x, int y) {
      this.x = x;
      this.y = y;
    }
  }
}
