% ---------------------------------------------------------------

% AI-Based Expert System for MBTI Personality Profiling.
% Group 26

% ---------------------------------------------------------------


:- dynamic trait/1.
:- dynamic username/1.

% Personality rules
personality(intj) :- trait(prefers_independent_work), trait(enjoys_problem_solving), trait(prefers_logical_thinking), trait(enjoys_solitude).
personality(intp) :- trait(prefers_independent_work), trait(enjoys_problem_solving), trait(prefers_imagination), trait(likes_experimenting).
personality(entj) :- trait(prefers_teamwork), trait(enjoys_problem_solving), trait(prefers_logical_thinking), trait(enjoys_talking).
personality(entp) :- trait(prefers_teamwork), trait(enjoys_problem_solving), trait(prefers_imagination), trait(likes_experimenting).
personality(infj) :- trait(prefers_independent_work), trait(enjoys_solitude), trait(prefers_imagination), trait(values_empathy).
personality(infp) :- trait(prefers_independent_work), trait(enjoys_solitude), trait(enjoys_art), trait(values_empathy).
personality(enfj) :- trait(prefers_teamwork), trait(enjoys_talking), trait(values_empathy), trait(prefers_imagination).
personality(enfp) :- trait(prefers_teamwork), trait(enjoys_talking), trait(enjoys_art), trait(likes_experimenting).
personality(istj) :- trait(prefers_independent_work), trait(values_structure), trait(enjoys_problem_solving), trait(prefers_logical_thinking).
personality(isfj) :- trait(prefers_independent_work), trait(values_structure), trait(enjoys_solitude), trait(values_empathy).
personality(estj) :- trait(prefers_teamwork), trait(values_structure), trait(enjoys_talking), trait(prefers_logical_thinking).
personality(esfj) :- trait(prefers_teamwork), trait(values_structure), trait(enjoys_talking), trait(values_empathy).
personality(istp) :- trait(prefers_independent_work), trait(enjoys_problem_solving), trait(likes_experimenting), trait(prefers_logical_thinking).
personality(isfp) :- trait(prefers_independent_work), trait(enjoys_art), trait(likes_experimenting), trait(values_empathy).
personality(estp) :- trait(prefers_teamwork), trait(enjoys_talking), trait(likes_experimenting), trait(prefers_logical_thinking).
personality(esfp) :- trait(prefers_teamwork), trait(enjoys_talking), trait(enjoys_art), trait(likes_experimenting).

% Question definitions
ask_question(prefers_independent_work, 'Do you prefer working alone rather than in a team?').
ask_question(prefers_teamwork, 'Do you enjoy working in a team?').
ask_question(enjoys_problem_solving, 'Do you enjoy solving logic puzzles or challenges?').
ask_question(prefers_logical_thinking, 'Do you usually make decisions based on logic rather than feelings?').
ask_question(enjoys_solitude, 'Do you enjoy spending time by yourself?').
ask_question(enjoys_talking, 'Do you enjoy conversations with new people?').
ask_question(enjoys_art, 'Do you enjoy creative activities such as art, music, or writing?').
ask_question(prefers_imagination, 'Do you often find yourself daydreaming or imagining abstract ideas?').
ask_question(likes_experimenting, 'Do you like experimenting and trying new things?').
ask_question(values_empathy, 'Do you consider other people\'s feelings when making decisions?').
ask_question(values_structure, 'Do you prefer clear plans and routines over spontaneity?').

% Input loop (instructions shown only at the beginning of the test)
ask(Trait, _) :-
    ask_question(Trait, Question),
    repeat,
    write('Q: '), write(Question), nl,
    read(Response),
    (
        Response == yes -> assertz(trait(Trait)), ! 
    ;   Response == no -> ! 
    ;   Response == quit -> writeln('Exiting system...'), halt
    ;   Response == menu -> throw(menu_interrupt)
    ;   writeln('Invalid input. Please type yes. or no.'), fail
    ).


% Safe run with graceful interrupt
safe_run :- 
    catch(run_test, Error, handle_error(Error)).

% Handle menu interruption gracefully
handle_error(menu_interrupt) :-
    writeln('\n________Returning to main menu._________\n'),
    menu.

% Ask user name
ask_name :-
    write('What is your name? '),
    read(Name),
    retractall(username(_)),
    assertz(username(Name)),
    format('\nWelcome, ~w! Let\'s begin your MBTI personality test.\n', [Name]).

% Time-based greeting
greeting :- 
    get_time(TS),
    stamp_date_time(TS, DateTime, local),
    DateTime = date(_, _, _, Hour, _, _, _, _, _),
    ( Hour < 12 -> writeln('\nGood morning!') ;
    Hour < 18 -> writeln('\nGood afternoon!') ;
    writeln('\nGood evening!') 
    ).

% Main logic
run_test :-
    retractall(trait(_)),
    writeln('\n----------------------------------------------------------------------------------'),
    greeting,
    ask_name,
    writeln('----------------------------------------------------------------------------------'),
    writeln('INSTRUCTIONS:'),
    write(' -> Type "yes." if your answer is Yes'), nl,
    write(' -> Type "no." if your answer is No'), nl,
    write(' -> Type "menu." to return to the Main Menu'), nl,
    write(' -> Type "quit." to exit the system'), nl,
    writeln('----------------------------------------------------------------------------------'),
    forall(ask_question(Trait, _), ask(Trait, _)),
    username(Name),
    ( personality(Type) -> 
        format('\n ~w, your MBTI personality type is: ~w\n', [Name, Type]),
        describe(Type),
        writeln('\nThanks for completing the test! Stay curious and keep growing.')
    ;   writeln('Unable to determine personality type. You may have mixed traits.')
    ).

% Personality descriptions

describe(intj) :- writeln('
INTJ : The Mastermind
- Strategic and future-oriented
- Independent thinker
- Great at long-term planning
- Logical and analytical
- Focused on solving big problems
Keep using your vision and logic to shape the future!
').

describe(intp) :- writeln('
INTP : The Thinker
- Curious and loves new ideas
- Enjoys exploring abstract concepts
- Independent and creative
- Thinks outside the box
- Enjoys understanding how things work
Keep questioning, exploring, and discovering new possibilities!
').

describe(entj) :- writeln('
ENTJ : The Commander
- Confident and strong leader
- Goal-oriented and efficient
- Focused on achieving results
- Decisive and determined
- Great at making plans and strategies
Keep leading with confidence and purpose, achieving greatness!
').

describe(entp) :- writeln('
ENTP : The Visionary
- Creative and full of energy
- Loves brainstorming and debating
- Thinks quickly on the spot
- Loves exploring new ideas
- Always ready for a challenge
Keep pushing boundaries and making bold moves towards innovation!
').

describe(infj) :- writeln('
INFJ : The Advocate
- Insightful and empathetic
- Strong sense of values
- Deep thinker and idealist
- Compassionate and caring
- Inspires others with their vision
Keep leading with compassion and inspiring positive change!
').

describe(infp) :- writeln('
INFP : The Mediator
- Imaginative and authentic
- Follows personal values
- Deeply creative and reflective
- Loves helping others understand themselves
- Expresses unique ideas with heart
Keep embracing your creativity and making a difference with your authenticity!
').

describe(enfj) :- writeln('
ENFJ : The Leader
- Charismatic and motivating
- Great communicator
- Values teamwork and cooperation
- Supports others with positivity
- Uplifts and inspires people
Keep leading with kindness and lifting others to their highest potential!
').

describe(enfp) :- writeln('
ENFP : The Explorer
- Enthusiastic and curious
- Enjoys freedom and creativity
- Loves meeting new people
- Values deep connections
- Always looking for new experiences
Keep exploring and making connections that open doors to new opportunities!
').

describe(istj) :- writeln('
ISTJ : The Responsible One
- Responsible and dependable
- Focused on details and facts
- Follows traditions and rules
- Likes order and structure
- Works hard to achieve success
Keep building a solid foundation and staying true to your values!
').

describe(isfj) :- writeln('
ISFJ : The Caregiver
- Loyal and caring
- Values stability and tradition
- Thoughtful and helpful
- Supports others quietly
- Works to make a difference in small ways
Keep nurturing and providing stability for those around you!
').

describe(estj) :- writeln('
ESTJ : The Organizer
- Organized and direct
- Focused on results and efficiency
- Strong sense of duty and leadership
- Practical and hardworking
- Manages situations with clear structure
Keep managing with clarity, precision, and a strong sense of responsibility!
').

describe(esfj) :- writeln('
ESFJ : The Helper
- Friendly and loyal
- Values teamwork and responsibility
- Helps create social harmony
- Cares about others well-being
- Strives to strengthen the community
Keep building connections and making the world a better place for everyone!
').

describe(istp) :- writeln('
ISTP : The Problem Solver
- Observant and logical
- Enjoys hands-on activities
- Solves problems with experience
- Thinks quickly and practically
- Likes to figure out how things work
Keep solving problems with your practical skills and hands-on approach!
').

describe(isfp) :- writeln('
ISFP : The Artist
- Creative and gentle
- Values beauty and personal expression
- Quiet and adaptable
- Enjoys personal freedom
- Expresses themselves through art
Keep expressing your creativity and bringing beauty into the world!
').

describe(estp) :- writeln('
ESTP : The Doer
- Bold and action-oriented
- Enjoys fast decisions and challenges
- Thrives in dynamic situations
- Confident and adaptable
- Loves to seize opportunities
Keep taking action and embracing the adventure life brings your way!
').

describe(esfp) :- writeln('
ESFP : The Entertainer
- Outgoing and fun-loving
- Brings energy to social situations
- Enjoys living in the moment
- Spreads joy and positivity
- Loves to entertain and connect with others
Keep spreading joy and living life to its fullest every day!
').

% Menu system
menu :-
    writeln('\n===== MBTI Personality Profiler ====='),
    writeln('1. Start New Assessment'),
    writeln('2. View All Personality Types'),
    writeln('3. Exit System'),
    write('\nSelect option (1-3): '),
    read(Choice),
    handle(Choice).

handle(1) :- safe_run, menu.
handle(2) :- show_all_types, menu.
handle(3) :- writeln('\n Goodbye! Take care.'), halt.
handle(_) :- writeln('\nInvalid choice. Try again.\n'), menu.

show_all_types :-
    writeln('\nList of All MBTI Types and Descriptions:'),
    describe(intj), describe(intp), describe(entj), describe(entp),
    describe(infj), describe(infp), describe(enfj), describe(enfp),
    describe(istj), describe(isfj), describe(estj), describe(esfj),
    describe(istp), describe(isfp), describe(estp), describe(esfp).

% Auto-start
:- initialization(menu).