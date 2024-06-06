class TerritoryQueen:
    def __init__(self, size):
        self.size = size
        self.board = self.generate_board()
        print(self.board)
        
    def generate_board(self):
        return [[0 for _ in range(self.size)] for _ in range(self.size)]
    
    
