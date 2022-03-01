import numpy as np


class CBVModel():
    """Count-based value model.
    """
    def __init__(self, game_version):
        """Initializes a little alchemy count-based value model.
        
        Args:
            game_version (str): 'joined', 'alchemy1', 'alchemy2', 'tinyalchemy' or 'tinypixels. 
                        States what element and combination set is going to be used.
        """
        # get number of elements
        if game_version == 'joined':
            self.n_elements = 738
        elif game_version == 'alchemy1' or game_version == 'tinyalchemy' or game_version == 'tinypixels':
            self.n_elements = 540
        elif game_version == 'alchemy2':
            self.n_elements = 720
        
    def get_value(self, combination):
        """Returns value for given combination.

        Args:
            combination (list): List of element indices that are involved in combination.

        Returns:
            float: Value.
        """
        return self.values_elements[combination[0]] + self.values_elements[combination[1]]
        
    def reset(self):
        """Resets model dependent information.
        """            
        self.values_elements = np.zeros(self.n_elements)
    
    def update_model_specifics(self, chosen_combination, results):
        """Updates model specifics.

        Args:
            chosen_combination (list): List of element indices that are involved in combination.
            result (tuple): Consists of
                        (1) new_results_non_final (list): List of non final element indices that resulted from combination.
                        (2) new_results_total (list): List of all new element indices that resulted from combination.
        """
        if len(results[1]) == 0:
            self.values_elements[chosen_combination[0]] -= 1
            self.values_elements[chosen_combination[1]] -= 1
        else: 
            self.values_elements[chosen_combination[0]] += len(results[1])
            self.values_elements[chosen_combination[1]] += len(results[1])
