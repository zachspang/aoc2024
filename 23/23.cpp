#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <algorithm>

using namespace std;

int main()
{
    ifstream file("input.txt");
    
    map<string, vector<string>> connections;
    string line;
    while (getline(file, line)) {
        if (line != "") {
            string left = line.substr(0, 2);
            string right = line.substr(3, 2);
            connections[left].push_back(right);
            connections[right].push_back(left);
        }
    }
    file.close();

    int p1Total = 0;

    //This runs pretty slow on the actual input because there are 3380 connections. By going through the map and removing any entries that dont contain t this would be faster
    //Make sure we only check in one order so connections arent recounted. Ex: only ta, de, co and not co, de, ta
    for (auto connection1 : connections) {
        for (auto connection2 : connections) {
            //If 1 > 2 and 1 contains 2
            if (connection1.first > connection2.first && count(connection1.second.begin(), connection1.second.end(), connection2.first) > 0) {
                for (auto connection3 : connections) {
                    //If 2 > 3 and 2 contains 3
                    if (connection2.first > connection3.first && (count(connection1.second.begin(), connection1.second.end(), connection3.first) > 0)) {
                        //If any contain a t
                        if (connection1.first.substr(0, 1) == "t" || connection2.first.substr(0, 1) == "t" || connection3.first.substr(0, 1) == "t") {
                            if (count(connection2.second.begin(), connection2.second.end(), connection3.first) > 0) {
                                p1Total++;
                            }

                        }
                    }
                }           
            }
        }
    }

    cout << p1Total << endl;
    
    vector<string> largestSet;
    //For each computer
    for (auto com: connections) {
        //For each connection of computer
        for (int i = 0; i < com.second.size(); i++) {
            vector<string> currentSet;
            currentSet.push_back(com.first);
            currentSet.push_back(com.second[i]);
            //For each computer the com is connected to check if it connected to the others, if it is add it to the set. 
            for (int j = i + 1; j < com.second.size(); j++) {
                bool inI = true;
                for (string computer : currentSet) {
                    if (count(connections[computer].begin(), connections[computer].end(), com.second[j]) == 0) {
                        inI = false;
                        break;
                    }
                }
                if (inI) {
                    currentSet.push_back(com.second[j]);
                }
            }
            if (currentSet.size() > largestSet.size()) {
                largestSet = currentSet;
            }
        }
    }
    sort(largestSet.begin(), largestSet.end());

    for (string computer : largestSet) {
        cout << computer;
        if (computer != largestSet[largestSet.size() - 1]) {
            cout << ",";
        }
    }
}