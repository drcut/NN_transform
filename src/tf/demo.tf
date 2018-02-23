learning_rate=0.001
training_iters=200000
batch_size=64
display_step=20

n_input=784
n_classes=10

x=tf.placeholder(tf.float32,[None,n_input])
y=tf.placeholder(tf.float32,[None,n_classes])
_dropout=tf.placeholder(tf.float32)

_X=tf.reshape(x,shape=[-1,28,28,1])      
conv1=tf.nn.relu(tf.nn.bias_add(tf.nn.conv2d(_X,tf.Variable(tf.random_normal([3,3,1,64])),strides=[1,1,1,1],padding='SAME'),tf.Variable(tf.random_normal([64]))),name='conv1')
