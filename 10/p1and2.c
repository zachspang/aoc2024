#include <stdio.h>
#include <stddef.h>
#include <string.h>
#include <stdbool.h>

int trailheadScore(int row, int col, char map[100][100],  int rowLen, int colLen, int previousNum, bool unique);
void restore9s(char map[100][100], int rowLen, int colLen);

int main() {
  FILE * file = fopen("input.txt", "r");
  char map[100][100];
  char line[100];
  
  int i = 0;
  while(1) {
    fgets(line, 100, file);
    if (feof(file))
      break;
    strcpy(map[i], line);
    i = i + 1;
  }
  
  int rowLen = strlen(map[0]) - 1;
  int colLen = i;
  int part1Total = 0;
  int part2Total = 0;
  for(int i = 0; i < rowLen; i++){
    for(int j = 0; j < colLen; j++){
      if(map[i][j] == '0') {
        part1Total = part1Total + trailheadScore(i, j, map, rowLen, colLen, -1, true);
        part2Total = part2Total + trailheadScore(i, j, map, rowLen, colLen, -1, false);
      }
    }
  }
  
  printf("\n%d", part1Total);
  printf("\n%d\n", part2Total);
  return 0;
}

int trailheadScore(int row, int col, char map[100][100],  int rowLen, int colLen, int previousNum, bool unique) {
  if(row < 0 || col < 0 || row >= rowLen || col >= colLen || map[row][col] - '0' -  previousNum != 1) {
    return 0;
  } 
  else if(map[row][col] == '9') {
    if(unique) {
      map[row][col] = '.';
    }
    return 1;
  }
  else {
    //Check up down left right
    int result =
      trailheadScore(row - 1, col, map, rowLen, colLen, map[row][col] - '0', unique) +
      trailheadScore(row + 1, col, map, rowLen, colLen, map[row][col] - '0', unique) +
      trailheadScore(row, col - 1, map, rowLen, colLen, map[row][col] - '0', unique) +
      trailheadScore(row, col + 1, map, rowLen, colLen, map[row][col] - '0', unique);
    if (previousNum == -1 && unique){
      restore9s(map, rowLen, colLen);
    }
    return result;
  }
}

void restore9s(char map[100][100], int rowLen, int colLen) {
  for(int i = 0; i < rowLen; i++){
    for(int j = 0; j < colLen; j++){
      if(map[i][j] == '.') {
        map[i][j] = '9';
      }
    }
  }
}