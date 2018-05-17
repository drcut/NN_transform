# The MNIST dataset has 10 classes, representing the digits 0 through 9.
NUM_CLASSES = 10

# The MNIST images are always 28x28 pixels.
IMAGE_SIZE = 28
IMAGE_PIXELS = IMAGE_SIZE * IMAGE_SIZE
hidden1_units = 50
hidden2_units = 50
images=tf.placeholder(tf.float32,[None])
labels=tf.placeholder(tf.float32,[None])
learning_rate=tf.placeholder(tf.float32)

with tf.name_scope('hidden1'):
  weights1 = tf.Variable(
        tf.truncated_normal([IMAGE_PIXELS, hidden1_units],
                            stddev=1.0),
        name='weights')
  biases1 = tf.Variable(tf.zeros([hidden1_units]),
                         name='biases')
  hidden1 = tf.nn.relu(tf.matmul(images, weights1) + biases1)
  # Hidden 2
with tf.name_scope('hidden2'):
  weights2 = tf.Variable(
        tf.truncated_normal([hidden1_units, hidden2_units],
                            stddev=1.0),
        name='weights')
  biases2 = tf.Variable(tf.zeros([hidden2_units]),
                         name='biases')
  hidden2 = tf.nn.relu(tf.matmul(hidden1, weights2) + biases2)
  # Linear
with tf.name_scope('softmax_linear'):
  weights3 = tf.Variable(
        tf.truncated_normal([hidden2_units, NUM_CLASSES],
                            stddev=1.0),
        name='weights')
  biases3 = tf.Variable(tf.zeros([NUM_CLASSES]),
                         name='biases')
  logits = tf.matmul(hidden2, weights3) + biases3

  loss = tf.losses.sparse_softmax_cross_entropy(labels, logits)
  #loss = tf.nn.softmax_cross_entropy_with_logits(labels, logits)

  optimizer = tf.train.GradientDescentOptimizer(learning_rate)

  train_op = optimizer.minimize(loss)

