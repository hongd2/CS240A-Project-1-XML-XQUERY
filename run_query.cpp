// to compile
// g++ -o run run_query.cpp -lxqilla -lxerces-c
// export LD_LIBRARY_PATH=/usr/local/lib
// ./run <query_file_name>
//
#include <iostream>
#include <xqilla/xqilla-simple.hpp>
#include <xqilla/runtime/Sequence.hpp>
#include <string>
#include <fstream>
#include <streambuf>

using namespace std;

int main(int argc, char *argv[]) {

    // check command line arguments
    if (argc < 2){
        cout << "Need name of query file" << endl;
        return 1;
    }

    // read query string from file to std::string
    std::ifstream t(argv[1]);
    std::string query_str;

    t.seekg(0, std::ios::end);   
    query_str.reserve(t.tellg());
    t.seekg(0, std::ios::beg);

    query_str.assign((std::istreambuf_iterator<char>(t)),
                std::istreambuf_iterator<char>());

    cout << "Query = " << query_str << endl;
    
    // Initialise Xerces-C and XQilla by creating the factory object
    XQilla xqilla;

    // Parse an XQuery expression
    // (AutoDelete deletes the object at the end of the scope)
    // AutoDelete<XQQuery> query(xqilla.parse(X("/employees/employee")));
    AutoDelete<XQQuery> query(xqilla.parse(X(query_str.c_str())));

    // Create a context object
    AutoDelete<DynamicContext> context(query->createDynamicContext());

    // Parse a document, and set it as the context item
    // Sequence seq = context->resolveDocument(X("v-depts.xml"));
    // if(!seq.isEmpty() && seq.first()->isNode()) {
    //     context->setContextItem(seq.first());
    //     context->setContextPosition(1);
    //     context->setContextSize(1);
    // }

    // Sequence seq2 = context->resolveDocument(X("v-emps.xml"));
    // if(!seq2.isEmpty() && seq2.first()->isNode()) {
    //     context->setContextItem(seq2.first());
    //     context->setContextPosition(2);
    //     context->setContextSize(2);
    // }

    // Execute the query, using the context
    Result result = query->execute(context);

    // Iterate over the results, printing them
    Item::Ptr item;
    while(item = result->next(context)) {
        std::cout << UTF8(item->asString(context)) << std::endl << std::endl;
    }

    return 0;
}
