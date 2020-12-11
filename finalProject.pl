%L is the total number of words in either spam emails or normal email
totalLen(Spm,L):-
  findall(I, totalLen2(Spm,I), Result),
  sumlist(Result,L).

totalLen2(Spm,I):-
  email(Y,Spm),
  length(Y,I).


%returns Len as the the number of occurences of "Word" in emails that are either spam or not spam
numOf(Word,Len,Spm):-
  findall(Y, email(Y,Spm), Result), %puts all words into one list to be searched
  flatten(Result, Flat), %flattens that list into one list
  occurances(Word,Flat,Len).


 %flatten multiple lists into 1 list (from lab)
flattenF([],[]).

flattenF([[]|L], L).

flattenF([X|L1], [X|L2]) :-
  atomic(X),
  flattenF(L1, L2).

flattenF([X|L1], L4) :-
  flattenF(X, L2),
  flattenF(L1, L3),
  append(L2, L3, L4).


%returns F as the number of occurences of the word in the list
occurances(Word,[Word|T],F):-
  occurances(Word,T,N),
  F is N+1,
  !.

occurances(Word,[X|T],F):-
  Word \= X,
  occurances(Word,T,F).

occurances(_,[],0).

distinctWords(Num):-
  findall(Y, email(Y,_), Result), %puts all words into one list to be searched
  flatten(Result, Flat), %flattens that list into one list
  sort(Flat,X),
  length(X,Num).

%returns Freq as the number of times a word occurs in either spam or not spam emails divided by the total number of words in either spam or not spam emails
%i.e. the percentage of the total words that are the given word
%1 is added to the length of all words to ensure that none have 0 and you dont end up multiplying by 0 later
%beaause 1 is added to all, the we must add 1 to all words, so we add the total numer of distinct words to the total number of words
freq(Word,Spm,Freq):-
  numOf(Word,Len,Spm),
  totalLen(Spm,L),
  distinctWords(Num),
  Freq is (Len+1)/(L+Num),
  !.

%calculate the proior probablility(P(NotSpam))
%words in non spam email / all words
priorProbNotSpam(Init):-
  totalLen(spam,L1),
  totalLen(not,L2),
  Total is L1 + L2,
  Init is L2/Total.


%calculate the proior probablility(P(NotSpam))
%words in spam email / all words
priorProbSpam(Init):-
  totalLen(spam,L1),
  totalLen(not,L2),
  Total is L1 + L2,
  Init is L1/Total.


%calculates the probability that a given list of words is a spam email
%return Prob as the proior probablility(P(spam)) * the probably of each given word being in a spam email P(word1|spam) * P(word2|spam) ...
probabilitySpam([H|T],Prob):-
  probabilitySpam(T,P),
  freq(H,spam,Freq),
  Prob is P*Freq,
  !.

probabilitySpam([], P):-
  priorProbSpam(Init),
  P is Init.


%calculates the probability that a given list of words is a spam email
%return Prob as the proior probablility(P(not Spam)) * the probably of each given word being in a spam email P(word1|not spam) * P(word2|not spam) ...
probabilityNotSpam([H|T], Prob):-
  probabilityNotSpam(T,P),
  freq(H,not,Freq),
  Prob is P*Freq,
  !.

probabilityNotSpam([], P):-
  priorProbNotSpam(Init),
  P is Init.


 %returns P1 as the probably that is is spam and P2 as the probably that is is not spam
isSpam(Aray,P1,P2):-
  probabilitySpam(Aray,P1),
  probabilityNotSpam(Aray,P2).
