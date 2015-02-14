// Program Zad170.cpp
#include <iostream.h>
#include "BinOrdTree.cpp"
typedef BinOrdTree<int> IntTree;
void main()
{IntTree t;
 t.Create();
 t.print();
 int x;
 char c;
 do
 {cout << "x: ";
  cin >> x;
  t.DeleteNode(x);
  t.print();
  cout << "next: y/n: ";
   cin >> c;
 } while (c == 'y');
 t.print();
}
template <class T>
void BinOrdTree<T>::pr1(const node<T>* p, int n) const
{if (p)
 {n = n + 5;
  pr1(p->Right, n);
  cout << setw(n) << p->inf << endl;
  pr1(p->Left, n);
 }
}
è
tempalate <class T>
void BinOrdTree<T>::print_tree()const
 {pr1(root, 0);
  cout << endl;
 }
template <class T>
bool member(T a, BinOrdTree<T> const& t)
{if (t.empty()) return false;
 if (a == t.RootTree()) return true;
 if (a < t.RootTree()) return member(a, t.LeftTree());
 else return member(a, t.RightTree());
}
