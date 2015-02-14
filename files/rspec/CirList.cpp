using namespace std;
template <class T>
struct elem
{T inf;
 elem *link;
};
template <class T>
class CirList
{public:
  CirList();
  ~CirList();
  CirList(CirList &);
  CirList& operator=(CirList &);
  void print();
  void IterStart(elem<T>* = NULL);
  elem<T>* Iter();
  void ToEnd(T &);
  void Insert(T &);
  void DeleteElem(elem<T>*, T &);
 private:
  elem<T> *Start,
	       *Current;
  void DeleteList();
  void CopyList(CirList &);
};
template <class T>
CirList<T>::CirList()
{Start = NULL;
}
template <class T>
CirList<T>::~CirList()
{DeleteList();
}
template <class T>
CirList<T>::CirList(CirList<T> & r)
{CopyList(r);
}
template <class T>
CirList<T>& CirList<T>::operator=(CirList<T> & r)
{if (this != &r)
 {DeleteList();
  CopyList(r);
 }
 return *this;
}
template <class T>
void CirList<T>::IterStart(elem<T> *p)
{if (p) Current = p;
 else
 if (!Start) Current = NULL;
 else Current = Start->link;
}
template <class T>
elem<T>* CirList<T>::Iter()
{if (!Current) return NULL;
 elem<T> *p = Current;
 if (Current == Start) Current = NULL;
  else Current = Current->link;
  return p;
 }
template <class T>
void CirList<T>::DeleteList()
{IterStart();
 elem<T> *p = Iter();
 while (p)
 {delete p;
  p = Iter();
 }
}
template <class T>
void CirList<T>::CopyList(CirList & r)
{Start = NULL;
 r.IterStart();
 elem<T> *p = r.Iter();
 while (p)
 {ToEnd(p->inf);
  p = r.Iter();
 }
}
template <class T>
void CirList<T>::Insert(T & x)
{elem<T> *p = new elem<T>;
 p->inf = x;
 if (Start) p->link = Start->link;
 else Start = p;
 Start->link = p;
}
template <class T>
void CirList<T>::ToEnd(T & x)
{Insert(x);
 Start = Start->link;
}
template <class T>
void CirList<T>::DeleteElem(elem<T>* p, T & x)
{x = p->inf;
 if (Start != Start->link)
 {elem<T> *q = Start;
  while (q->link != p) q = q->link;
  q->link = p->link;
  if (p == Start) Start = q;
  delete p;
 }
 else
 {Start = NULL;
  delete p;
 }
}
template <class T>
void CirList<T>::print()
{IterStart();
 elem<T> *p = Iter();
 while (p)
 {cout << p->inf << " ";
  p = Iter();
 }
 cout << endl;
}

