import pandas as pd
import networkx as nx
from pyvis.network import Network
from IPython.core.display import display, HTML

# max order to compute comm graph
max_order = 45
gap('LoadPackage("GGraph");')

small_groups = gap(f'AllSmallGroups([1..{max_order}], x->(not IsAbelian(x)));')

for G in list(small_groups):
    # Pega o isomorfismo com subgrupo do grupo de perm.
    # Para questões de visualização nos grafos
    G_hom = gap.function_call('IsomorphismPermGroup', G)
    G = gap.function_call('Image', G_hom) 
    elements_list = list(gap.function_call('Elements', G))
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
                    print(f'Wrong elements: {str(e1)} {str(target_elm)}')
    
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

    group_id = list(gap.function_call('IdGroup', [G]))

    net.from_nx(com_graph)
    net.show_buttons()
    #net.show('example2.html')
    file_str = f'comm_graph_plots/{group_id[0]}_{group_id[1]}_comm_graph.html'
    net.save_graph(file_str)
    # display(HTML('example.html'))
