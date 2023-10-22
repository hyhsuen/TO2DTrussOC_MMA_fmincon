% Created with:       FlExtract v1.13
% Element type:       truss
% Number of nodes:    33
% Number of elements: 92


% Node coordinates: x, y
X = [
0	0
0	1
0	2
0.8	0
0.8	1
0.8	2
1.6	0
1.6	1
1.6	2
2.4	0
2.4	1
2.4	2
3.2	0
3.2	1
3.2	2
4	0
4	1
4	2
4.8	0
4.8	1
4.8	2
5.6	0
5.6	1
5.6	2
6.4	0
6.4	1
6.4	2
7.2	0
7.2	1
7.2	2
8	0
8	1
8	2
];
% Element connectivity: node1_id, node2_id, material_id
IX = [
2	1	1
5	1	1
4	1	1
3	2	1
6	2	1
5	2	1
4	2	1
6	3	1
5	3	1
5	4	1
8	4	1
7	4	1
6	5	1
9	5	1
8	5	1
7	5	1
9	6	1
8	6	1
8	7	1
11	7	1
10	7	1
9	8	1
12	8	1
11	8	1
10	8	1
12	9	1
11	9	1
11	10	1
14	10	1
13	10	1
12	11	1
15	11	1
14	11	1
13	11	1
15	12	1
14	12	1
14	13	1
17	13	1
16	13	1
15	14	1
18	14	1
17	14	1
16	14	1
18	15	1
17	15	1
17	16	1
20	16	1
19	16	1
18	17	1
21	17	1
20	17	1
19	17	1
21	18	1
20	18	1
20	19	1
23	19	1
22	19	1
21	20	1
24	20	1
23	20	1
22	20	1
24	21	1
23	21	1
23	22	1
26	22	1
25	22	1
24	23	1
27	23	1
26	23	1
25	23	1
27	24	1
26	24	1
26	25	1
29	25	1
28	25	1
27	26	1
30	26	1
29	26	1
28	26	1
30	27	1
29	27	1
29	28	1
32	28	1
31	28	1
30	29	1
33	29	1
32	29	1
31	29	1
33	30	1
32	30	1
32	31	1
33	32	1
];
% Element properties: Young's modulus, area
mprop = [
1	1
2	2
];
% Nodal diplacements: node_id, degree of freedom (1 - x, 2 - y), displacement
bound = [
1	1	0
1	2	0
2	1	0
2	2	0
3	1	0
3	2	0
];
% Nodal loads: node_id, degree of freedom (1 - x, 2 - y), load
loads = [
32	2	-0.01
];
% Control parameters
plotdof = 2;
