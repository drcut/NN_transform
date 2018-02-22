matrix1 = tf.constant([[3., 3.]])

matrix2 = tf.constant([[2.],[2.]])
product = tf.matmul   ( matrix1, matrix2,transpose_a=False,transpose_b=False)
