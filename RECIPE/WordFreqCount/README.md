# Counting Words

This example gives a stream-based implementation that counts words
in a given on-line source and then sort these words according to they
frequencies.

We need a small package of the name *atscntrb-hx-teaching-bucs* to
turn the source referred to by a URL into a linear stream of
characters.  This package can be downloaded by executing
```make npm-install``` or by issuing the following command-line:

```shell
npm install atscntrb-hx-teaching-bucs
```

We can implement a function ```stream_by_url_``` based on one of the
name ```stream_by_command``` in the downloaded package:
  
```ats
local

#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies.hats"

#staload
BUCS520 =
$BUCS520_2016_FALL

in

extern
fun
stream_by_url_
(url: string): stream_vt(char)

implement
stream_by_url_(url) =
$BUCS520.stream_by_command<>
  ("wget", $list{string}("-q", "-O", "-", url))

end // end of [local]
```

The function ```stream_by_url_``` calls the command ```wget```
(with some options) to fetch the source referred to by a given URL.
One can of course try to implement ```stream_by_url_``` based
on the command ```curl``` as well.

We use the following type aliases in the rest of the presentation:

```ats
typedef word = string
typedef nword = (int, string)
```

Given a list of words ordered ascendingly
(according to the standard lexicographic ordering),
the following function returns a list of pairs where
each pair consists of a number and a distinct word
such that the number indicates the number of times
the word occurring in the original given list of words:

```ats
extern
fun
list_vt_word2nword
(ws: List_vt(word)): List0_vt(nword)
```

Probably the most interesting function in this example is the following
one that turns a linear stream of chars into a linear stream of words:

```ats
extern
fun
stream_vt_char2word
(cs: stream_vt(char)): stream_vt(word)

implement
stream_vt_char2word
  (cs) =
  auxmain(cs) where
{
  fun
  auxmain
  (
  cs: stream_vt(char)
  ) : stream_vt(word) =
  (
    case+ !cs of
    | ~stream_vt_nil() =>
       stream_vt_make_nil()
    | ~stream_vt_cons(c0, cs) =>
      (
       if isalpha(c0)
         then $ldelay
              (auxmain_con(cs, list_vt_sing(L(c0))), ~(cs))
         else auxmain(cs)
      )
  )
  
  and
  auxmain_con
  (
  cs: stream_vt(char), w0: List0_vt(char)
  ) : stream_vt_con(word) =
  (
    case+ !cs of
    | ~stream_vt_nil() =>
       stream_vt_sing(string_make_rlist_vt(w0))
    | ~stream_vt_cons(c1, cs) =>
      (
       if isalpha(c1)
         then auxmain_con(cs, list_vt_cons(L(c1), w0))
         else stream_vt_cons(string_make_rlist_vt(w0), auxmain(cs))
      )
  )
} (* end of [stream_vt_char2word] *)
```

Note that each word is just a non-empty sequence of letters in the
English alphabet. Also, each word in the returned stream consists of
only lowercase letters. Both ```auxmain``` and ```auxmain_con``` are
tail-recursive, presenting no risk of stack-overflow even when they
are called on a linear stream of infinite length! In general, paying
close attention to addressing potential risk of stack-overflow is of
great importance in constructing code of high quality.


The function ```stream_vt_char2nword``` does the work of assembling:

```ats
extern
fun
stream_vt_char2nword
  (cs: stream_vt(char)): List0_vt(nword)

implement
stream_vt_char2nword(cs) = nws where
{
  val ws = stream_vt_char2word(cs)
  val ws = stream2list_vt<word>(ws)
  val ws = list_vt_mergesort_fun<word>(ws, lam(w1, w2) => compare(w1, w2))
  val nws = list_vt_word2nword(ws)
  val nws = list_vt_mergesort_fun<nword>(nws, lam(nw1, nw2) => ~compare(nw1.0, nw2.0))
}
```

The code implementing ```stream_vt_char2nword``` is self-explanatory.

When the default URL is used, the execution of the program in this example
output the following table that lists the first 250 most frequently used words
in the novel *Moby-Dick* by Herman Melville:

```text
1	the -> 14715
2	of -> 6742
3	and -> 6517
4	a -> 4805
5	to -> 4707
6	in -> 4241
7	that -> 3100
8	it -> 2536
9	his -> 2532
10	i -> 2127
11	he -> 1900
12	s -> 1825
13	but -> 1823
14	with -> 1770
15	as -> 1753
16	is -> 1751
17	was -> 1646
18	for -> 1644
19	all -> 1545
20	this -> 1443
21	at -> 1335
22	whale -> 1245
23	by -> 1227
24	not -> 1173
25	from -> 1105
26	on -> 1073
27	him -> 1069
28	so -> 1066
29	be -> 1064
30	you -> 964
31	one -> 925
32	there -> 871
33	or -> 798
34	now -> 786
35	had -> 779
36	have -> 774
37	were -> 683
38	they -> 670
39	which -> 655
40	like -> 647
41	me -> 633
42	then -> 631
43	their -> 620
44	are -> 619
45	some -> 619
46	what -> 619
47	when -> 607
48	an -> 600
49	no -> 596
50	my -> 589
51	upon -> 568
52	out -> 539
53	man -> 530
54	up -> 526
55	into -> 523
56	ship -> 519
57	ahab -> 517
58	more -> 509
59	if -> 501
60	them -> 474
61	ye -> 473
62	we -> 469
63	sea -> 455
64	old -> 452
65	would -> 432
66	other -> 431
67	been -> 415
68	over -> 410
69	these -> 406
70	will -> 399
71	though -> 384
72	its -> 382
73	down -> 379
74	only -> 378
75	such -> 376
76	who -> 366
77	any -> 364
78	head -> 348
79	yet -> 345
80	boat -> 337
81	long -> 334
82	time -> 334
83	her -> 332
84	captain -> 329
85	do -> 324
86	here -> 324
87	very -> 323
88	about -> 318
89	still -> 312
90	than -> 311
91	chapter -> 308
92	great -> 307
93	those -> 307
94	said -> 305
95	before -> 301
96	two -> 298
97	has -> 294
98	must -> 293
99	t -> 291
100	most -> 285
101	seemed -> 283
102	white -> 281
103	last -> 278
104	see -> 275
105	way -> 273
106	whales -> 272
107	thou -> 271
108	after -> 270
109	again -> 263
110	stubb -> 261
111	how -> 259
112	did -> 258
113	your -> 258
114	may -> 255
115	queequeg -> 253
116	little -> 249
117	can -> 247
118	round -> 247
119	while -> 246
120	sperm -> 245
121	three -> 245
122	men -> 244
123	say -> 244
124	first -> 239
125	through -> 235
126	us -> 234
127	every -> 232
128	well -> 230
129	being -> 225
130	much -> 224
131	where -> 223
132	off -> 220
133	could -> 217
134	good -> 216
135	hand -> 215
136	same -> 215
137	our -> 211
138	side -> 208
139	ever -> 206
140	never -> 206
141	himself -> 205
142	look -> 205
143	own -> 205
144	deck -> 199
145	starbuck -> 199
146	almost -> 197
147	go -> 194
148	even -> 193
149	water -> 190
150	thing -> 188
151	away -> 186
152	should -> 185
153	too -> 185
154	might -> 183
155	come -> 180
156	day -> 179
157	made -> 178
158	pequod -> 178
159	life -> 176
160	world -> 176
161	sir -> 175
162	fish -> 171
163	many -> 168
164	among -> 167
165	far -> 165
166	seen -> 165
167	back -> 164
168	without -> 164
169	line -> 160
170	let -> 158
171	oh -> 157
172	right -> 157
173	cried -> 156
174	eyes -> 156
175	nor -> 156
176	aye -> 155
177	god -> 153
178	know -> 153
179	part -> 153
180	night -> 152
181	sort -> 152
182	thought -> 150
183	once -> 149
184	boats -> 147
185	air -> 143
186	crew -> 141
187	don -> 140
188	take -> 137
189	whole -> 137
190	full -> 136
191	half -> 136
192	against -> 135
193	tell -> 135
194	things -> 134
195	thus -> 134
196	whaling -> 133
197	thee -> 131
198	came -> 130
199	hands -> 130
200	mast -> 130
201	small -> 130
202	soon -> 130
203	each -> 129
204	feet -> 127
205	both -> 126
206	under -> 126
207	something -> 123
208	till -> 123
209	think -> 122
210	between -> 120
211	she -> 120
212	why -> 119
213	found -> 118
214	just -> 117
215	place -> 117
216	called -> 116
217	saw -> 116
218	another -> 115
219	ll -> 115
220	make -> 115
221	nothing -> 115
222	towards -> 115
223	poor -> 114
224	thy -> 113
225	times -> 112
226	along -> 110
227	body -> 110
228	heard -> 110
229	work -> 110
230	flask -> 109
231	high -> 108
232	stand -> 107
233	moment -> 105
234	sight -> 105
235	end -> 103
236	voyage -> 103
237	new -> 102
238	sail -> 102
239	sun -> 102
240	hold -> 99
241	shall -> 99
242	does -> 98
243	strange -> 98
244	nantucket -> 97
245	went -> 97
246	years -> 97
247	however -> 96
248	leviathan -> 96
249	face -> 95
250	few -> 95
```

Happy programming in ATS!!!
