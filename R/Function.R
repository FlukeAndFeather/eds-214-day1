
# Function of the moving average

  moving_ave <- function(focal_date, dates, conc, win_size_wks) {
    # Which dates are in the window?
    is_in_window <- (dates > focal_date - (win_size_wks / 2) * 7) &
      (dates < focal_date + (win_size_wks / 2) * 7)
    # Find the associated concentrations
    window_conc <- conc[is_in_window]
    # Calculate the mean
    result <- mean(window_conc)
    
    return(result)
  }
  
  
  #Q1: What is the task?  
    
  #  - Refactor your code by writing a function to perform a task
  
#  Q2: What are the task’s inputs? What data and parameters do you need to know to do the task?
  
  # focal_date, dates, conc, win_size_wks
    
#   Q3: What is the task’s output? Be specific! If it’s a vector, what type (e.g., character or numeric) is it and how long is it? If it’s a data frame, what are the column names and what are their types? Are there constraints on what the output can be (e.g., sorted, range limits, etc)?
    
  # 
  
#  Q4: Which lines of code in your spaghetti currently perform the task?