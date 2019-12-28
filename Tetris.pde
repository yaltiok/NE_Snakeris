class Tetris {
  boolean[][] board;
  boolean[][] droppedPieces;
  PVector[] snakeLocation = new PVector[4];
  ArrayList<TetrisPiece> pieces = new ArrayList();
  ArrayList<TetrisPiece> landedPieces = new ArrayList();
  int cols;
  int rows;
  int xOrder;
  int yOrder;
  int cellSize;
  boolean pieceFalling = false;
  float score = 0;

  Tetris(int cols, int rows, int xOrder, int yOrder, int cellSize) {
    this.cols = cols;
    this.rows = rows;
    this.xOrder = xOrder + 1;
    this.yOrder = yOrder + 1;
    this.cellSize = cellSize;
    initBoards();
  }


  void checkBoard() {
    for (int i = rows - 1; i >= 5; i--) {
      int sum = 0;
      for (int j = cols -1; j >= 0; j--) {
        if (droppedPieces[j][i]) {
          sum++;
        }
      }
      if (sum >= cols) {
        deleteRow(i);
      }
    }
  }

  void lowerBoard(int index) {
    for (int i = index; i >= 1; i--) {
      for (int j = 0; j < cols; j++) {
        if (droppedPieces[j][i-1]) {
          droppedPieces[j][i-1] = false;
          droppedPieces[j][i] = true;
        }
      }
    }
    checkBoard();
  }

  void deleteRow(int index) {
    for (int i = 0; i < droppedPieces.length; i++) {
      droppedPieces[i][index] = false;
    }
    score += 20;
    lowerBoard(index);
  }

  void update(boolean show) {
    dropDown();
    if (show) {
      show();
    }
  }
  
  float getTetrisScore(){
    return score;
  }

  void show() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (board[i][j] || droppedPieces[i][j]) {
          float x = cellSize*(i + (xOrder - 1) * cols);
          float y = cellSize*(j + (yOrder - 1) * rows);
          push();
          fill(255, 0, 0);
          rect(x, y, cellSize, cellSize);
          pop();
        }
      }
    }
  }

  void setSnakeLocation(Snake snake) {
    for (int i = 0; i < snakeLocation.length; i++) {
      int indexX = floor(snake.snake[i].x/cellSize) - (xOrder - 1) * cols;
      int indexY = floor(snake.snake[i].y/cellSize) - (yOrder - 1) * rows;
      snakeLocation[i] = new PVector(indexX, indexY);
    }
    pieces.add(new TetrisPiece(snakeLocation));
    snakeLocation = new PVector[4];
  }


  void dropDown() {
    for (TetrisPiece o : pieces) {
      if (!o.landed) {
        o.update();
      }
    }
  }

  void initBoards() {
    board = new boolean[cols][rows];
    droppedPieces = new boolean[cols][rows];
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        board[i][j] = false;
        droppedPieces[i][j] = false;
      }
    }
  }


  // When player eats a food. A tetris object is created from current snake.
  class TetrisPiece {


    PVector[] arr = new  PVector[4];
    boolean landed = false;

    TetrisPiece(PVector[] snek) {
      this.arr = snek;
      for (int k = 0; k < arr.length; k++) {
        int idx_i = floor(arr[k].x);
        int idx_j = floor(arr[k].y);
        board[idx_i][idx_j] = true;
      }
      landed = checkLand();
    }

    void addToDroppedBoard() {
      for (int k = 0; k < arr.length; k++) {
        int idx_i = floor(arr[k].x);
        int idx_j = floor(arr[k].y);
        droppedPieces[idx_i][idx_j] = true;
        board[idx_i][idx_j] = false;
      }
    }

    void update() {
      for (int k = 0; k < arr.length; k++) {
        int idx_i = floor(arr[k].x);
        int idx_j = floor(arr[k].y);
        if (arr[k].y * cellSize < height - cellSize/2) {
          board[idx_i][idx_j] = false;
          arr[k].y += 1;
        }
      }
      for (int k = 0; k < arr.length; k++) {
        if (arr[k].y * cellSize < height - cellSize/2) {
          int idx_i = floor(arr[k].x);
          int idx_j = floor(arr[k].y);
          board[idx_i][idx_j] = true;
        }
      }
      landed = checkLand();
      if (landed) {
        checkBoard();
      }
    }

    boolean checkLand() {
      for (int k = 0; k < arr.length; k++) {

        int idx_i = floor(arr[k].x);
        int idx_j = floor(arr[k].y);

        if (idx_j + 1 == rows) {
          addToDroppedBoard();
          pieceFalling = false;
          return true;
        } else if (droppedPieces[idx_i][idx_j + 1] == true) {
          addToDroppedBoard();
          pieceFalling = false;
          return true;
        }
      }
      return false;
    }
  }
}
