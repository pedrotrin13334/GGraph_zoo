import pandas as pd
import networkx as nx
from pyvis.network import Network
from IPython.core.display import display, HTML

G = SymmetricGroup(4)
gap('LoadPackage("GGraph");')

elements_list = G.list()

source = []
target = []
# Plots Commutative graph using GGraph package
com_graph = gap.function_call('CommGraph', [G]) 
grape_graph = gap.get_record_element(com_graph, 'graph')
sanity_check = 0
for idx, e1 in enumerate(elements_list):
    adjacency = gap.function_call('Adjacency', [grape_graph, idx+1])
    for e_idx in adjacency:
        if e1 == elements_list[int(e_idx)-1]:
            pass
        else:
            source.append(str(e1))
            target_elm = elements_list[int(e_idx)-1]
            target.append(str(target_elm))

            if e1*target_elm == target_elm*e1:
                sanity_check += 1
            else:
                print()
                print(f'{str(e1)} {str(target_elm)}')
    
if sanity_check != len(target):
    print('The commutative graph is wrong')
else:
    print('Everything went ok')
# print(target)
data = {'Source': source,
        'Target': target}

df = pd.DataFrame(data)
com_graph = nx.from_pandas_edgelist(df,
                                    source='Source',
                                    target='Target')

net = Network(height='1000px', width='80%', heading='')

net.from_nx(com_graph)
net.show_buttons()
net.show('example2.html')
# display(HTML('example.html'))
