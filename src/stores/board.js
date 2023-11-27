import { defineStore } from "pinia";

export const useBoardStore = defineStore("board", {
  state: () => ({
    boardData: null,
  }),
  actions: {
    readBoard(board) {
      this.boardData = board;
    },
  },
  persist: true,
});
