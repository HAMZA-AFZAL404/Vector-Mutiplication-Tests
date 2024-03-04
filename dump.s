
test.elf:     file format elf64-littleriscv


Disassembly of section .text:

0080000000000000 <matrix1-0x8>:
  80000000000000:	7880306f          	j	80000000003788 <rvtest_entry_point>
  80000000000004:	00000013          	nop

0080000000000008 <matrix1>:
	...

0080000000001288 <matrix2>:
	...

0080000000002508 <result_matrix>:
	...

0080000000003788 <rvtest_entry_point>:
  80000000003788:	53fd                	li	t2,-1
  8000000000378a:	3b039073          	csrw	pmpaddr0,t2
  8000000000378e:	43bd                	li	t2,15
  80000000003790:	3a039073          	csrw	pmpcfg0,t2
  80000000003794:	12000073          	sfence.vma
  80000000003798:	18001073          	csrw	satp,zero
  8000000000379c:	ffffd517          	auipc	a0,0xffffd
  800000000037a0:	86c50513          	add	a0,a0,-1940 # 80000000000008 <matrix1>
  800000000037a4:	ffffe597          	auipc	a1,0xffffe
  800000000037a8:	ae458593          	add	a1,a1,-1308 # 80000000001288 <matrix2>
  800000000037ac:	4601                	li	a2,0
  800000000037ae:	6685                	lui	a3,0x1

00800000000037b0 <init_loop>:
  800000000037b0:	00c50023          	sb	a2,0(a0)
  800000000037b4:	00c58023          	sb	a2,0(a1)
  800000000037b8:	0505                	add	a0,a0,1
  800000000037ba:	0585                	add	a1,a1,1
  800000000037bc:	0605                	add	a2,a2,1
  800000000037be:	fed649e3          	blt	a2,a3,800000000037b0 <init_loop>
  800000000037c2:	00000517          	auipc	a0,0x0
  800000000037c6:	0d250513          	add	a0,a0,210 # 80000000003894 <vm_enable>
  800000000037ca:	0cf00593          	li	a1,207
  800000000037ce:	8131                	srl	a0,a0,0xc
  800000000037d0:	052a                	sll	a0,a0,0xa
  800000000037d2:	8d4d                	or	a0,a0,a1
  800000000037d4:	0000e317          	auipc	t1,0xe
  800000000037d8:	82c30313          	add	t1,t1,-2004 # 80000000011000 <pgtb_l2>
  800000000037dc:	32000293          	li	t0,800
  800000000037e0:	9316                	add	t1,t1,t0
  800000000037e2:	00a33023          	sd	a0,0(t1)
  800000000037e6:	ffffd517          	auipc	a0,0xffffd
  800000000037ea:	82250513          	add	a0,a0,-2014 # 80000000000008 <matrix1>
  800000000037ee:	0cf00593          	li	a1,207
  800000000037f2:	8131                	srl	a0,a0,0xc
  800000000037f4:	052a                	sll	a0,a0,0xa
  800000000037f6:	8d4d                	or	a0,a0,a1
  800000000037f8:	0000e317          	auipc	t1,0xe
  800000000037fc:	80830313          	add	t1,t1,-2040 # 80000000011000 <pgtb_l2>
  80000000003800:	32000293          	li	t0,800
  80000000003804:	9316                	add	t1,t1,t0
  80000000003806:	00a33023          	sd	a0,0(t1)
  8000000000380a:	ffffe517          	auipc	a0,0xffffe
  8000000000380e:	a7e50513          	add	a0,a0,-1410 # 80000000001288 <matrix2>
  80000000003812:	0cf00593          	li	a1,207
  80000000003816:	8131                	srl	a0,a0,0xc
  80000000003818:	052a                	sll	a0,a0,0xa
  8000000000381a:	8d4d                	or	a0,a0,a1
  8000000000381c:	0000d317          	auipc	t1,0xd
  80000000003820:	7e430313          	add	t1,t1,2020 # 80000000011000 <pgtb_l2>
  80000000003824:	32000293          	li	t0,800
  80000000003828:	9316                	add	t1,t1,t0
  8000000000382a:	00a33023          	sd	a0,0(t1)
  8000000000382e:	fffff517          	auipc	a0,0xfffff
  80000000003832:	cda50513          	add	a0,a0,-806 # 80000000002508 <result_matrix>
  80000000003836:	0cf00593          	li	a1,207
  8000000000383a:	8131                	srl	a0,a0,0xc
  8000000000383c:	052a                	sll	a0,a0,0xa
  8000000000383e:	8d4d                	or	a0,a0,a1
  80000000003840:	0000d317          	auipc	t1,0xd
  80000000003844:	7c030313          	add	t1,t1,1984 # 80000000011000 <pgtb_l2>
  80000000003848:	32000293          	li	t0,800
  8000000000384c:	9316                	add	t1,t1,t0
  8000000000384e:	00a33023          	sd	a0,0(t1)
  80000000003852:	0000df97          	auipc	t6,0xd
  80000000003856:	7aef8f93          	add	t6,t6,1966 # 80000000011000 <pgtb_l2>
  8000000000385a:	fff00f1b          	addw	t5,zero,-1
  8000000000385e:	1f7e                	sll	t5,t5,0x3f
  80000000003860:	00cfdf93          	srl	t6,t6,0xc
  80000000003864:	01efefb3          	or	t6,t6,t5
  80000000003868:	180f9073          	csrw	satp,t6
  8000000000386c:	019005b7          	lui	a1,0x1900
  80000000003870:	2585                	addw	a1,a1,1 # 1900001 <vpn+0x18ffce1>
  80000000003872:	05b2                	sll	a1,a1,0xc
  80000000003874:	d1058593          	add	a1,a1,-752
  80000000003878:	6289                	lui	t0,0x2
  8000000000387a:	8002829b          	addw	t0,t0,-2048 # 1800 <vpn+0x14e0>
  8000000000387e:	3002b073          	csrc	mstatus,t0
  80000000003882:	6305                	lui	t1,0x1
  80000000003884:	8003031b          	addw	t1,t1,-2048 # 800 <vpn+0x4e0>
  80000000003888:	30032073          	csrs	mstatus,t1
  8000000000388c:	34159073          	csrw	mepc,a1
  80000000003890:	30200073          	mret

0080000000003894 <vm_enable>:
  80000000003894:	0001                	nop

0080000000003896 <main>:
  80000000003896:	1910051b          	addw	a0,zero,401
  8000000000389a:	0572                	sll	a0,a0,0x1c
  8000000000389c:	0511                	add	a0,a0,4
  8000000000389e:	0c90059b          	addw	a1,zero,201
  800000000038a2:	05f6                	sll	a1,a1,0x1d
  800000000038a4:	40458593          	add	a1,a1,1028
  800000000038a8:	01930637          	lui	a2,0x1930
  800000000038ac:	2605                	addw	a2,a2,1 # 1930001 <vpn+0x192fce1>
  800000000038ae:	0632                	sll	a2,a2,0xc
  800000000038b0:	80460613          	add	a2,a2,-2044
  800000000038b4:	04000293          	li	t0,64

00800000000038b8 <outer_loop>:
  800000000038b8:	000506b3          	add	a3,a0,zero
  800000000038bc:	000587b3          	add	a5,a1,zero
  800000000038c0:	04000f93          	li	t6,64

00800000000038c4 <inner_loop>:
  800000000038c4:	00078733          	add	a4,a5,zero
  800000000038c8:	4301                	li	t1,0
  800000000038ca:	04000f13          	li	t5,64

00800000000038ce <dot_product_loop>:
  800000000038ce:	0006c383          	lbu	t2,0(a3) # 1000 <vpn+0xce0>
  800000000038d2:	00074e03          	lbu	t3,0(a4)
  800000000038d6:	03c383b3          	mul	t2,t2,t3
  800000000038da:	931e                	add	t1,t1,t2
  800000000038dc:	0685                	add	a3,a3,1
  800000000038de:	04070713          	add	a4,a4,64
  800000000038e2:	1f7d                	add	t5,t5,-1
  800000000038e4:	fe0f15e3          	bnez	t5,800000000038ce <dot_product_loop>
  800000000038e8:	00660023          	sb	t1,0(a2)
  800000000038ec:	0605                	add	a2,a2,1
  800000000038ee:	0785                	add	a5,a5,1
  800000000038f0:	fc068693          	add	a3,a3,-64
  800000000038f4:	1ffd                	add	t6,t6,-1
  800000000038f6:	fc0f97e3          	bnez	t6,800000000038c4 <inner_loop>
  800000000038fa:	04050513          	add	a0,a0,64
  800000000038fe:	12fd                	add	t0,t0,-1
  80000000003900:	fa029ce3          	bnez	t0,800000000038b8 <outer_loop>
  80000000003904:	a009                	j	80000000003906 <test_pass>

0080000000003906 <test_pass>:
  80000000003906:	4081                	li	ra,0
  80000000003908:	a011                	j	8000000000390c <exit>

008000000000390a <test_fail>:
  8000000000390a:	4085                	li	ra,1

008000000000390c <exit>:
  8000000000390c:	0086                	sll	ra,ra,0x1
  8000000000390e:	0085                	add	ra,ra,1
  80000000003910:	8f26                	mv	t5,s1
  80000000003912:	00010f17          	auipc	t5,0x10
  80000000003916:	6e1f2723          	sw	ra,1774(t5) # 80000000014000 <tohost>

008000000000391a <self_loop>:
  8000000000391a:	a001                	j	8000000000391a <self_loop>
  8000000000391c:	0000                	unimp
  8000000000391e:	0000                	unimp
	...

Disassembly of section .data:

0080000000010000 <pgtb_l3>:
	...

0080000000011000 <pgtb_l2>:
	...

0080000000012000 <pgtb_l1>:
	...

0080000000013000 <pgtb_l0>:
	...

0080000000014000 <tohost>:
	...

0080000000014010 <fromhost>:
	...

Disassembly of section .riscv.attributes:

0000000000000000 <.riscv.attributes>:
   0:	aa41                	j	190 <vpn-0x190>
   2:	0000                	unimp
   4:	7200                	ld	s0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <vpn-0x30c>
   c:	00a0                	add	s0,sp,72
   e:	0000                	unimp
  10:	7205                	lui	tp,0xfffe1
  12:	3676                	fld	fa2,376(sp)
  14:	6934                	ld	a3,80(a0)
  16:	7032                	.2byte	0x7032
  18:	5f31                	li	t5,-20
  1a:	326d                	addw	tp,tp,-5 # fffffffffffe0ffb <_end+0xff7ffffffffccfe3>
  1c:	3070                	fld	fa2,224(s0)
  1e:	615f 7032 5f31      	.byte	0x5f, 0x61, 0x32, 0x70, 0x31, 0x5f
  24:	3266                	fld	ft4,120(sp)
  26:	3270                	fld	fa2,224(a2)
  28:	645f 7032 5f32      	.byte	0x5f, 0x64, 0x32, 0x70, 0x32, 0x5f
  2e:	30703263          	vmsge.vx	v4,v7,zero,v0.t
  32:	765f 7031 5f30      	.byte	0x5f, 0x76, 0x31, 0x70, 0x30, 0x5f
  38:	697a                	ld	s2,408(sp)
  3a:	32727363          	bgeu	tp,t2,360 <vpn+0x40>
  3e:	3070                	fld	fa2,224(s0)
  40:	7a5f 6669 6e65      	.byte	0x5f, 0x7a, 0x69, 0x66, 0x65, 0x6e
  46:	32696563          	bltu	s2,t1,370 <vpn+0x50>
  4a:	3070                	fld	fa2,224(s0)
  4c:	7a5f 6d6d 6c75      	.byte	0x5f, 0x7a, 0x6d, 0x6d, 0x75, 0x6c
  52:	7031                	c.lui	zero,0xfffec
  54:	5f30                	lw	a2,120(a4)
  56:	767a                	ld	a2,440(sp)
  58:	3365                	addw	t1,t1,-7 # ffffffffffff9ff9 <_end+0xff7ffffffffe5fe1>
  5a:	6632                	ld	a2,264(sp)
  5c:	7031                	c.lui	zero,0xfffec
  5e:	5f30                	lw	a2,120(a4)
  60:	767a                	ld	a2,440(sp)
  62:	3365                	addw	t1,t1,-7
  64:	7832                	ld	a6,296(sp)
  66:	7031                	c.lui	zero,0xfffec
  68:	5f30                	lw	a2,120(a4)
  6a:	767a                	ld	a2,440(sp)
  6c:	3665                	addw	a2,a2,-7
  6e:	6434                	ld	a3,72(s0)
  70:	7031                	c.lui	zero,0xfffec
  72:	5f30                	lw	a2,120(a4)
  74:	767a                	ld	a2,440(sp)
  76:	3665                	addw	a2,a2,-7
  78:	6634                	ld	a3,72(a2)
  7a:	7031                	c.lui	zero,0xfffec
  7c:	5f30                	lw	a2,120(a4)
  7e:	767a                	ld	a2,440(sp)
  80:	3665                	addw	a2,a2,-7
  82:	7834                	ld	a3,112(s0)
  84:	7031                	c.lui	zero,0xfffec
  86:	5f30                	lw	a2,120(a4)
  88:	767a                	ld	a2,440(sp)
  8a:	316c                	fld	fa1,224(a0)
  8c:	3832                	fld	fa6,296(sp)
  8e:	3162                	fld	ft2,56(sp)
  90:	3070                	fld	fa2,224(s0)
  92:	7a5f 6c76 3233      	.byte	0x5f, 0x7a, 0x76, 0x6c, 0x33, 0x32
  98:	3162                	fld	ft2,56(sp)
  9a:	3070                	fld	fa2,224(s0)
  9c:	7a5f 6c76 3436      	.byte	0x5f, 0x7a, 0x76, 0x6c, 0x36, 0x34
  a2:	3162                	fld	ft2,56(sp)
  a4:	3070                	fld	fa2,224(s0)
  a6:	0800                	add	s0,sp,16
  a8:	0a01                	add	s4,s4,0
  aa:	0b              	Address 0xaa is out of bounds.
