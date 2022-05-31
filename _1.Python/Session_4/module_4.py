PASSING_GRADE = 10

"""Task 1   Create class Trainee, whose constructor receives Trainees' name and surname."""
class Trainee:

    # Class Trainee shows trainees artibutes

    def __init__(self, name, surname):
        self.name = name
        self.surname = surname
        self.visited_lectures = 0
        self.done_home_tasks = 0
        self.missed_lectures = 0
        self.missed_home_tasks = 0
        self.mark = 0

    """Task 2     Create method visit_lecture. 
    This method has to be able to add 1 point to visited_lectures attribute."""
    def visit_lecture(self):
        # Function adds 1 pont if lecture is visited
        self.visited_lectures += 1
        self._add_points(1)

    """Task 3     Create method do_homework. 
    This method has to be able to add 2 points to done_home_tasks attribute."""
    def do_homework(self):
         # Function adds 2 point if hw is done
        self.done_home_tasks += 2
        self._add_points(2)

    """Task 4     Create method miss_lecture. 
    This method has to be able to subtract 1 point from the missed_lectures attribute."""
    def miss_lecture(self):
        # Function subtract 1 point if lecture is missed
        self.missed_lectures -= 1
        self._subtract_points(1)

    """Task 5     Create method miss_homework. 
    This method has to be able to subtract 2 point from the missed_homework attribute."""
    def miss_homework(self):
        # Function subtract 2 point if hw isn't done
        self.missed_home_tasks -= 2
        self._subtract_points(2)

    """Task 6     Create method _add_points. 
    This method has to be able to add a certain number of points to the mark attribute depending upon where it is used either in visit_lecture or in do_homework."""
    def _add_points(self, points: int):
        # Function increases mark and checks if it is not more than 10
        self.mark += points
        if self.mark > 10:
            self.mark = 10  #The mark can't be more than 10

    """Task 7     Create method _subtract_points. 
    This method has to be able to subtract a certain number of points to the mark attribute depending upon where it is used either in miss_lecture or in miss_homework."""
    def _subtract_points(self, points):
        # Function decreases mark and checks if it is not less than 0
        self.mark -= points
        if self.mark < 0:
            self.mark = 0   #The mark can't be less than 0

    """Task 8     Create method is_passed.
    If mark attribute is equal or more than 8 points, you need to print this phrase: "Good job!".
    Otherwise, print "You need to {here is missing points} points. Try to do your best!"."""
    def is_passed(self):
        # Function prints string based on students performance
        if self.mark >= 8:
            print(f'Good job!')
        else:
            print(f'You need to {8 - self.mark} points. Try to do your best!.')


    def __str__(self):
        status = f"Trainee {self.name.title()} {self.surname.title()}:\n" \
                 f"done homework {self.done_home_tasks} points;\n" \
                 f"missed homework {self.missed_home_tasks} points;\n" \
                 f"visited lectures {self.visited_lectures} points;\n" \
                 f"missed lectures {self.missed_lectures} points;\n" \
                 f"current mark {self.mark};\n" \

        return status
