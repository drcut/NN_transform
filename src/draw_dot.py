def main():
    with open('net_file.txt') as f:
        msg = f.readline().split()
        node_num = msg[0]
        edge_num = msg[1]
        print(node_num,edge_num)
        node_name = []
        node_op = []
        node_attr = []
        edge_s = []
        edge_e = []
        for idx in range(int(node_num)):
            node_name.append(f.readline().strip())
            node_op.append(f.readline().strip())
            node_attr.append(f.readline().strip())
        
        for idx in range(int(edge_num)):
            s = f.readline().strip().split()
            edge_s.append(s[0])
            edge_e.append(s[1])
            print(s[0],s[1])
    
    filename = 'sample.dot'
    with open(filename,'w') as f:
        f.write("digraph G{\nsize = \"5, 5\";\n")
        for idx in range(len(node_name)):
            f.write("{}[label=\"{}\",comment=\"{}\"];\n".format(node_name[idx],node_op[idx],node_attr[idx]))
        for idx in range(len(edge_s)):
            f.write("{}->{};\n".format(node_name[int(edge_s[idx])],node_name[int(edge_e[idx])]))
        f.write("}")
if __name__ == '__main__':
	main()