import networkx as nx               
import matplotlib.pyplot as plt     
'''
G = nx.DiGraph()                      

G.add_node(1)                       
G.add_edge(2, 3)                    
G.add_edge(3, 2)                    
G.add_edge(1, 2)
G.add_edge(1, 3)

pos = nx.spring_layout(G)           
colors = ['r','r','y']              
nx.draw(G, with_labels=True, node_color=colors, node_size=200)  
plt.show()  
'''
node_name = []
node_attr = []
G = nx.DiGraph()                      
with open('net_file.txt','r') as f:
    node_num , edge_num = f.readline().split()
    print(node_num,edge_num)
    for idx in range(0,int(node_num)):
        node_name.append(f.readline())
        node_attr.append(f.readline())
        #print(node_attr[-1])
    for _ in range(0,int(edge_num)):
        #print(f.readline().split())
        l,r = f.readline().split()
        G.add_edge(l,r) 
pos = nx.spring_layout(G)           
colors = ['r','r','y']              
nx.draw(G, with_labels=True, node_color=colors, node_size=200)  
plt.show()  
