1) Write an assembly program that passes two 16 bit values as array addresses and an address of a variable that is updated within the subroutine. In C language convention the following program must be implemented in assembly language.

```c
int list1[10], list2[10];
int result;
void main() {
sublab1(list1, list2, &result);
}
void sublab1(int *ls1, int *ls2, int *res)
{
int i, sum=0;
for(i=0;i<10;i++) {
sum += ls1[i]+ls2[i];
}
*res=sum;
}
```

2) Write an assembly program that passes two 16 bit values as array addresses and a value (length of the arrays). In C language convention the following program must be implemented in assembly language.

```c
int list1[10], list2[10];
int result;
void main() {
sublab2(list1, list2, 10);
}
void sublab2(int *ls1, int *ls2, int len)
{
int i, tmp;
for(i=0;i<len;i++) {
tmp = ls1[i];
 ls1[i]=ls2[len-1-i];
ls2[len-1-i]=tmp;
}
}
```
