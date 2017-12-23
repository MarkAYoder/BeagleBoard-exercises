# Work from: https://www.oreilly.com/learning/hello-tensorflow
import tensorflow as tf

graph = tf.get_default_graph()
graph.get_operations()
input_value = tf.constant(1.0)

operations = graph.get_operations()
operations
operations[0].node_def

sess = tf.Session()
sess.run(input_value)

weight = tf.Variable(0.8)
for op in graph.get_operations(): print(op.name)
output_value = weight * input_value

op = graph.get_operations()[-1]
op.name

for op_input in op.inputs: print(op_input)

init = tf.global_variables_initializer()
sess.run(init)
sess.run(output_value)

x = tf.constant(1.0, name='input')
w = tf.Variable(0.8, name='weight')
y = tf.multiply(w, x, name='output')

summary_writer = tf.summary.FileWriter('log_simple_stats', sess.graph)

y_ = tf.constant(0.0, name='correct_value')
optim = tf.train.GradientDescentOptimizer(learning_rate=0.025)
grads_and_vars = optim.compute_gradients(loss)
sess.run(tf.initialize_all_variables())
sess.run(grads_and_vars[1][0])
sess.run(optim.apply_gradients(grads_and_vars))
sess.run(w)

loss = tf.pow(y - y_, 2, name='loss')
train_step = tf.train.GradientDescentOptimizer(0.025).minimize(loss)
for i in range(100):
    sess.run(train_step)

sess.run(y)

sess.run(tf.initialize_all_variables())
for i in range(100):
    print('before step {}, y is {}'.format(i, sess.run(y)))
    sess.run(train_step)

summary_y = tf.summary.scalar('output', y)
