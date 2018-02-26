import networkx as nx               
import matplotlib.pyplot as plt     
node_name = []
node_attr = []
node_op = []
G = nx.DiGraph()                      
with open('net_file.txt','r') as f:
    node_num , edge_num = f.readline().split()
    print(node_num,edge_num)
    for idx in range(0,int(node_num)):
        node_name.append(f.readline().strip('\n'))
        node_op.append(f.readline().strip('\n'))
        node_attr.append(f.readline().strip('\n'))
        #print(node_attr[-1])
    for _ in range(0,int(edge_num)):
        #print(f.readline().split())
        l,r = f.readline().strip('\n').split()
        G.add_edge(node_op[int(l)]+":"+l,node_op[int(r)]+":"+r)
        G.add_node(node_op[int(l)]+":"+l,attr = node_attr[int(l)],name = node_name[int(l)]) 
        G.add_node(node_op[int(r)]+":"+r,attr = node_attr[int(r)],name = node_name[int(r)]) 
#pos = nx.spectral_layout(G)           
nx.draw_spring(G, with_labels=True, node_size=200)  
plt.show()  
