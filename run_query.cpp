// to compile
// g++ -o run run_query.cpp -lxqilla -lxerces-c
// export LD_LIBRARY_PATH=/usr/local/lib
// ./run
//
#include <iostream>
#include <xqilla/xqilla-simple.hpp>
#include <xqilla/runtime/Sequence.hpp>

int main(int argc, char *argv[]) {
  // Initialise Xerces-C and XQilla by creating the factory object
  XQilla xqilla;

  // Parse an XQuery expression
  // (AutoDelete deletes the object at the end of the scope)
  AutoDelete<XQQuery> query(xqilla.parse(X("/employees/employee")));

  // Create a context object
  AutoDelete<DynamicContext> context(query->createDynamicContext());

  // Parse a document, and set it as the context item
  Sequence seq = context->resolveDocument(X("v-depts.xml"));
  if(!seq.isEmpty() && seq.first()->isNode()) {
    context->setContextItem(seq.first());
    context->setContextPosition(1);
    context->setContextSize(1);
  }

  Sequence seq2 = context->resolveDocument(X("v-emps.xml"));
  if(!seq2.isEmpty() && seq2.first()->isNode()) {
    context->setContextItem(seq2.first());
    context->setContextPosition(2);
    context->setContextSize(1);
  }

  // Execute the query, using the context
  Result result = query->execute(context);

  // Iterate over the results, printing them
  Item::Ptr item;
  while(item = result->next(context)) {
    std::cout << UTF8(item->asString(context)) << std::endl;
  }

  return 0;
}
