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

pool1=tf.nn.max_pool(conv1,ksize=[1,2,2,1],strides=[1,2,2,1],padding='SAME',name='pool1')
norm1=tf.nn.lrn(pool1,depth_radius = 4,bias=1.0,alpha=0.001,beta=0.75,name='norm1')
drop1=tf.nn.dropout(norm1,_dropout)

conv2=tf.nn.relu(tf.nn.bias_add(tf.nn.conv2d(drop1,tf.Variable(tf.random_normal([3,3,64,128])),strides=[1,1,1,1],padding='SAME'),tf.Variable(tf.random_normal([128]))),name='conv2')
pool2=tf.nn.max_pool(conv2,ksize=[1,2,2,1],strides=[1,2,2,1],padding='SAME',name='pool2')
norm2=tf.nn.lrn(pool2,depth_radius = 4,bias=1.0,alpha=0.001,beta=0.75,name='norm2')
drop2=tf.nn.dropout(norm2,_dropout)

conv3=tf.nn.relu(tf.nn.bias_add(tf.nn.conv2d(drop2,tf.Variable(tf.random_normal([3,3,128,256])),strides=[1,1,1,1],padding='SAME'),tf.Variable(tf.random_normal([256]))),name='conv3')
pool3=tf.nn.max_pool(conv3,ksize=[1,2,2,1],strides=[1,2,2,1],padding='SAME',name='pool3')
norm3=tf.nn.lrn(pool3,depth_radius = 4,bias=1.0,alpha=0.001,beta=0.75,name='norm3')
drop3=tf.nn.dropout(norm3,_dropout)

dense1=tf.reshape(drop3,shape=[-1,4*4*256])
dense1=tf.nn.relu(tf.matmul(dense1,tf.Variable(tf.random_normal([4*4*256,1024]))+tf.Variable(tf.random_normal([1024])),name='fc1'))
dense2=tf.nn.relu(tf.matmul(dense1,tf.Variable(tf.random_normal([1024,1024]))+tf.Variable(tf.random_normal([1024])),name='fc2'))
pred=tf.matmul(dense2,tf.Variable(tf.random_normal([1024,10]))+tf.Variable(tf.random_normal([n_classes])))

cost=tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(pred,y))

optimizer=tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost)

