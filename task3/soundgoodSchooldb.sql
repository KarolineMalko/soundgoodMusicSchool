--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: adminstrator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adminstrator (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    person_number bigint NOT NULL,
    email character varying(150) NOT NULL
);


ALTER TABLE public.adminstrator OWNER TO postgres;

--
-- Name: adminstrator_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adminstrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adminstrator_id_seq OWNER TO postgres;

--
-- Name: adminstrator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adminstrator_id_seq OWNED BY public.adminstrator.id;


--
-- Name: audition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audition (
    id integer NOT NULL,
    date date NOT NULL,
    skill_determine character varying(150) NOT NULL,
    instructor_id integer NOT NULL
);


ALTER TABLE public.audition OWNER TO postgres;

--
-- Name: audition_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audition_id_seq OWNER TO postgres;

--
-- Name: audition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audition_id_seq OWNED BY public.audition.id;


--
-- Name: ensemble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble (
    id integer NOT NULL,
    genre character varying(100) NOT NULL,
    instructor_id integer NOT NULL,
    min_number_of_students integer NOT NULL,
    max_number_of_students integer NOT NULL,
    particular_level character varying(150) NOT NULL,
    start_date date NOT NULL,
    number_of_student integer NOT NULL,
    price integer NOT NULL
);


ALTER TABLE public.ensemble OWNER TO postgres;

--
-- Name: group_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_lesson (
    id integer NOT NULL,
    start_date date NOT NULL,
    instructor_id integer NOT NULL,
    min_number_of_students integer NOT NULL,
    max_number_of_students integer NOT NULL,
    number_of_students integer NOT NULL,
    instrument_kind character varying NOT NULL
);


ALTER TABLE public.group_lesson OWNER TO postgres;

--
-- Name: individual_lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.individual_lesson (
    id integer NOT NULL,
    instructor_id integer NOT NULL,
    instrument_kind character varying(150) NOT NULL,
    particular_level character varying(150) NOT NULL,
    start_date date NOT NULL,
    student_id integer NOT NULL,
    price integer NOT NULL
);


ALTER TABLE public.individual_lesson OWNER TO postgres;

--
-- Name: avg_lessons_per_month; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.avg_lessons_per_month AS
 SELECT year_months.mm AS month,
    round(((((count(ind_res.id))::numeric + (count(group_res.id))::numeric) + (count(ens_re.id))::numeric) / (3)::numeric), 2) AS total_lessons
   FROM (((( SELECT to_char((CURRENT_DATE - ('1 mon'::interval * (s.a)::double precision)), 'MM'::text) AS mm
           FROM generate_series(1, 12, 1) s(a)) year_months
     LEFT JOIN ( SELECT individual_lesson.id,
            individual_lesson.instructor_id,
            individual_lesson.instrument_kind,
            individual_lesson.particular_level,
            individual_lesson.start_date,
            individual_lesson.student_id,
            individual_lesson.price
           FROM public.individual_lesson) ind_res ON (((EXTRACT(year FROM ind_res.start_date) = (2022)::numeric) AND (EXTRACT(month FROM ind_res.start_date) = ((year_months.mm)::integer)::numeric))))
     LEFT JOIN ( SELECT group_lesson.id,
            group_lesson.start_date,
            group_lesson.instructor_id,
            group_lesson.min_number_of_students,
            group_lesson.max_number_of_students,
            group_lesson.number_of_students,
            group_lesson.instrument_kind
           FROM public.group_lesson) group_res ON (((EXTRACT(year FROM group_res.start_date) = (2022)::numeric) AND (EXTRACT(month FROM group_res.start_date) = ((year_months.mm)::integer)::numeric))))
     LEFT JOIN ( SELECT ensemble.id,
            ensemble.genre,
            ensemble.instructor_id,
            ensemble.min_number_of_students,
            ensemble.max_number_of_students,
            ensemble.particular_level,
            ensemble.start_date,
            ensemble.number_of_student,
            ensemble.price
           FROM public.ensemble) ens_re ON (((EXTRACT(year FROM ens_re.start_date) = (2022)::numeric) AND (EXTRACT(month FROM ens_re.start_date) = ((year_months.mm)::integer)::numeric))))
  GROUP BY year_months.mm
  ORDER BY year_months.mm
  WITH NO DATA;


ALTER TABLE public.avg_lessons_per_month OWNER TO postgres;

--
-- Name: ensemble_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ensemble_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ensemble_id_seq OWNER TO postgres;

--
-- Name: ensemble_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ensemble_id_seq OWNED BY public.ensemble.id;


--
-- Name: group_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.group_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.group_lesson_id_seq OWNER TO postgres;

--
-- Name: group_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.group_lesson_id_seq OWNED BY public.group_lesson.id;


--
-- Name: individual_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.individual_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.individual_lesson_id_seq OWNER TO postgres;

--
-- Name: individual_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.individual_lesson_id_seq OWNED BY public.individual_lesson.id;


--
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    id integer NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    person_number character varying(150) NOT NULL,
    street character varying(150) NOT NULL,
    city character varying(150) NOT NULL,
    zip_code integer NOT NULL
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- Name: instructor_contact_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_contact_info (
    instructor_id integer NOT NULL,
    phone_number bigint NOT NULL,
    email_address character varying(100) NOT NULL
);


ALTER TABLE public.instructor_contact_info OWNER TO postgres;

--
-- Name: instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instructor_id_seq OWNER TO postgres;

--
-- Name: instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_id_seq OWNED BY public.instructor.id;


--
-- Name: instructor_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_payment (
    instructor_id integer NOT NULL,
    lessons_amount_price integer NOT NULL,
    amount_lessons integer NOT NULL
);


ALTER TABLE public.instructor_payment OWNER TO postgres;

--
-- Name: instructor_tot_given_less; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.instructor_tot_given_less AS
SELECT
    NULL::character varying(150) AS first_name,
    NULL::bigint AS instructor_tot_lessons;


ALTER TABLE public.instructor_tot_given_less OWNER TO postgres;

--
-- Name: instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument (
    id integer NOT NULL,
    kind character varying(100) NOT NULL,
    type character varying(100) NOT NULL,
    brand character varying(100) NOT NULL,
    price integer DEFAULT 300 NOT NULL
);


ALTER TABLE public.instrument OWNER TO postgres;

--
-- Name: instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrument_id_seq OWNER TO postgres;

--
-- Name: instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_id_seq OWNED BY public.instrument.id;


--
-- Name: instrument_rental; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_rental (
    id integer NOT NULL,
    instrument_id integer NOT NULL,
    student_id integer NOT NULL,
    rental_date date NOT NULL,
    return_date date NOT NULL,
    rental_period smallint NOT NULL,
    delivery_method character varying(50) NOT NULL,
    terminated boolean NOT NULL
);


ALTER TABLE public.instrument_rental OWNER TO postgres;

--
-- Name: instrument_rental_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_rental_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrument_rental_id_seq OWNER TO postgres;

--
-- Name: instrument_rental_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_rental_id_seq OWNED BY public.instrument_rental.id;


--
-- Name: lessons_per_month; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.lessons_per_month AS
 SELECT year_months.mm,
    count(ind_res.id) AS individual_lessons,
    count(group_res.id) AS group_lessons,
    count(ens_re.id) AS ensembles_lessons,
    ((count(ind_res.id) + count(group_res.id)) + count(ens_re.id)) AS total_lessons
   FROM (((( SELECT to_char((CURRENT_DATE - ('1 mon'::interval * (s.a)::double precision)), 'MM'::text) AS mm
           FROM generate_series(1, 12, 1) s(a)) year_months
     LEFT JOIN ( SELECT individual_lesson.id,
            individual_lesson.instructor_id,
            individual_lesson.instrument_kind,
            individual_lesson.particular_level,
            individual_lesson.start_date,
            individual_lesson.student_id,
            individual_lesson.price
           FROM public.individual_lesson) ind_res ON (((EXTRACT(year FROM ind_res.start_date) = (2022)::numeric) AND (EXTRACT(month FROM ind_res.start_date) = ((year_months.mm)::integer)::numeric))))
     LEFT JOIN ( SELECT group_lesson.id,
            group_lesson.start_date,
            group_lesson.instructor_id,
            group_lesson.min_number_of_students,
            group_lesson.max_number_of_students,
            group_lesson.number_of_students,
            group_lesson.instrument_kind
           FROM public.group_lesson) group_res ON (((EXTRACT(year FROM group_res.start_date) = (2022)::numeric) AND (EXTRACT(month FROM group_res.start_date) = ((year_months.mm)::integer)::numeric))))
     LEFT JOIN ( SELECT ensemble.id,
            ensemble.genre,
            ensemble.instructor_id,
            ensemble.min_number_of_students,
            ensemble.max_number_of_students,
            ensemble.particular_level,
            ensemble.start_date,
            ensemble.number_of_student,
            ensemble.price
           FROM public.ensemble) ens_re ON (((EXTRACT(year FROM ens_re.start_date) = (2022)::numeric) AND (EXTRACT(month FROM ens_re.start_date) = ((year_months.mm)::integer)::numeric))))
  GROUP BY year_months.mm
  ORDER BY year_months.mm
  WITH NO DATA;


ALTER TABLE public.lessons_per_month OWNER TO postgres;

--
-- Name: parent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parent (
    student_id integer NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    person_number integer NOT NULL,
    phone_number integer NOT NULL,
    email_addr character varying(150) NOT NULL
);


ALTER TABLE public.parent OWNER TO postgres;

--
-- Name: siblings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siblings (
    id integer NOT NULL,
    student_id integer NOT NULL,
    sibling_id integer NOT NULL
);


ALTER TABLE public.siblings OWNER TO postgres;

--
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    instrument_id integer NOT NULL,
    instruments_quantity integer NOT NULL
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id integer NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    person_number character varying(150) NOT NULL,
    street character varying(150) NOT NULL,
    city character varying(150) NOT NULL,
    zip_code integer NOT NULL,
    sibling character varying(150) NOT NULL,
    rented_instrument_amount integer NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_application (
    id integer NOT NULL,
    student_id integer NOT NULL,
    enrollment_date date NOT NULL
);


ALTER TABLE public.student_application OWNER TO postgres;

--
-- Name: student_application_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_application_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_application_id_seq OWNER TO postgres;

--
-- Name: student_application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_application_id_seq OWNED BY public.student_application.id;


--
-- Name: student_contact_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_contact_info (
    student_id integer NOT NULL,
    phone_number bigint NOT NULL,
    email_addr character varying(150)
);


ALTER TABLE public.student_contact_info OWNER TO postgres;

--
-- Name: student_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_payment (
    id integer NOT NULL,
    student_id integer NOT NULL,
    individual_lessons_amount smallint,
    advanced_lessons_amount smallint,
    ensembles_amount smallint,
    group_lessons_amount smallint,
    payment_date date,
    intermediate_less_amount smallint,
    beginner_less_amount smallint,
    previous_month_charge integer NOT NULL
);


ALTER TABLE public.student_payment OWNER TO postgres;

--
-- Name: student_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_payment_id_seq OWNER TO postgres;

--
-- Name: student_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_payment_id_seq OWNED BY public.student_payment.id;


--
-- Name: student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_student_id_seq OWNER TO postgres;

--
-- Name: student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_student_id_seq OWNED BY public.student.id;


--
-- Name: adminstrator id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adminstrator ALTER COLUMN id SET DEFAULT nextval('public.adminstrator_id_seq'::regclass);


--
-- Name: audition id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audition ALTER COLUMN id SET DEFAULT nextval('public.audition_id_seq'::regclass);


--
-- Name: ensemble id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble ALTER COLUMN id SET DEFAULT nextval('public.ensemble_id_seq'::regclass);


--
-- Name: group_lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson ALTER COLUMN id SET DEFAULT nextval('public.group_lesson_id_seq'::regclass);


--
-- Name: individual_lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson ALTER COLUMN id SET DEFAULT nextval('public.individual_lesson_id_seq'::regclass);


--
-- Name: instructor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor ALTER COLUMN id SET DEFAULT nextval('public.instructor_id_seq'::regclass);


--
-- Name: instrument id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument ALTER COLUMN id SET DEFAULT nextval('public.instrument_id_seq'::regclass);


--
-- Name: instrument_rental id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental ALTER COLUMN id SET DEFAULT nextval('public.instrument_rental_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_student_id_seq'::regclass);


--
-- Name: student_application id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_application ALTER COLUMN id SET DEFAULT nextval('public.student_application_id_seq'::regclass);


--
-- Name: student_payment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_payment ALTER COLUMN id SET DEFAULT nextval('public.student_payment_id_seq'::regclass);


--
-- Data for Name: adminstrator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adminstrator (id, first_name, last_name, person_number, email) FROM stdin;
\.


--
-- Data for Name: audition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audition (id, date, skill_determine, instructor_id) FROM stdin;
\.


--
-- Data for Name: ensemble; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ensemble (id, genre, instructor_id, min_number_of_students, max_number_of_students, particular_level, start_date, number_of_student, price) FROM stdin;
1	Art Punk	1	10	30	beginner	2023-02-16	23	1500
2	Alternative Rock	3	10	30	intermediate	2023-03-17	13	2000
3	Britpunk	6	10	30	advanced	2023-08-07	20	2500
4	College Rock	12	10	30	advanced	2023-11-13	24	2500
5	Crossover Thrash	4	10	30	advanced	2022-06-22	15	2500
7	Grunge	10	10	30	intermediate	2023-06-09	30	2000
9	Indie Rock	3	10	30	beginner	2023-06-29	23	1500
10	Britpunk	4	10	30	intermediate	2023-09-15	19	2000
11	College Rock	7	10	30	beginner	2023-01-11	16	1500
12	Experimental Rock	9	10	30	intermediate	2023-06-14	29	2000
8	Hard Rock	2	10	30	beginner	2022-01-22	10	1500
6	Experimental Rock	13	10	30	advanced	2023-02-20	29	2500
\.


--
-- Data for Name: group_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_lesson (id, start_date, instructor_id, min_number_of_students, max_number_of_students, number_of_students, instrument_kind) FROM stdin;
1	2022-01-03	3	10	30	23	Trumpet
2	2023-03-08	12	10	30	12	Saxophone
3	2023-05-08	5	10	30	26	Clarinet
4	2022-08-05	8	10	30	18	Violin
5	2022-10-24	13	10	30	20	Saxophone
6	2022-11-14	1	10	30	30	Piano
8	2022-10-27	5	10	30	14	Clarinet
10	2023-01-17	4	10	30	29	Piano
11	2023-10-24	2	10	30	26	Trumpet
9	2022-01-07	9	10	30	19	Violin
7	2022-01-22	3	10	30	10	Trumpet
\.


--
-- Data for Name: individual_lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.individual_lesson (id, instructor_id, instrument_kind, particular_level, start_date, student_id, price) FROM stdin;
1	2	Trumpet	beginner	2022-06-30	27	500
2	4	Violin	intermediate	2022-07-21	17	1000
3	7	Clarinet	advanced	2022-12-26	13	1500
4	1	Piano	beginner	2022-10-05	22	500
5	11	Violin	intermediate	2022-06-22	25	1000
6	13	Saxophone	advanced	2022-06-14	29	1500
7	10	Clarinet	intermediate	2022-12-08	5	1000
8	6	Violin	beginner	2022-02-18	30	500
9	8	Drums	advanced	2023-01-31	1	1500
10	9	Piano	beginner	2022-08-01	4	500
11	3	Drums	intermediate	2022-02-15	20	1000
12	1	Drums	advanced	2022-04-12	23	1500
13	5	Piano	beginner	2022-08-15	15	500
14	4	Saxophone	advanced	2022-10-20	6	1500
16	12	Violin	advanced	2022-09-21	2	1500
15	1	Piano	advanced	2022-01-24	3	1500
\.


--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor (id, first_name, last_name, person_number, street, city, zip_code) FROM stdin;
1	Alys	Gross	19760302-7116	LothianPoplars	Stockholm	16052
2	Indigo	Sellers	19810312-0275	HarcourtBroadway	Solna	18723
3	Madina	Morley	19910625-9303	ReimsCourt	Stockholm	36691
5	Layla	Soto	19810825-6827	FallKirk	Södertälje	70568
6	Skyla	Tillman	19840424-4065	Tredaffydd	Södertälje	52671
7	Eric	Burks	19850530-8941	LyntonCommon	Södertälje	49373
8	Orson	Felix	19820506-4803	LeeHills	Sollentuna	33007
9	Lara	Harvey	19940523-3693	BeattyCross	Sollentuna	26150
10	Eduardo	Woodcock	19850429-9318	LaneGlebe	Stockholm	95813
11	Dillan	Krueger	1981071-5823	BrickfieldTown	Tumba	97576
12	Tayyibah	Odom	19920330-3264	PearlPassage	Solna	7908
13	Caoimhe	Davenport	17331230-2772	MarmionHills	Stockholm	71803
14	Roy	Hurley	19830525-0266	PretoriaBanks	Sollentuna	71989
4	Katelyn	Sheridan	19860418-4259	BurlywoodClose	Solna	84224
\.


--
-- Data for Name: instructor_contact_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor_contact_info (instructor_id, phone_number, email_address) FROM stdin;
\.


--
-- Data for Name: instructor_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor_payment (instructor_id, lessons_amount_price, amount_lessons) FROM stdin;
\.


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument (id, kind, type, brand, price) FROM stdin;
6	Trumpet	Brass	Yamaha	300
1	Piano	String	Bösendorfer	950
2	Violin	String	Nikola Zubak by Kennedy	400
3	Drums	Percussion	Tama	650
4	Saxophone	Woodwind	Selmer Paris	250
5	Clarinet	Woodwind	Jupiter	250
7	Drums	Percussion	Selmer Paris	300
8	Clarinet	Woodwind	Yamaha	400
9	Trumpet	Brass	Jupiter	450
\.


--
-- Data for Name: instrument_rental; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_rental (id, instrument_id, student_id, rental_date, return_date, rental_period, delivery_method, terminated) FROM stdin;
1	1	2	2022-01-08	2022-03-08	12	Pick up	f
4	4	15	2022-01-08	2022-03-08	12	Deliver to house	f
5	4	2	2022-01-08	2022-03-08	12	Deliver to house	t
2	2	12	2022-01-08	2022-03-08	12	Pick up	t
3	1	3	2022-01-08	2022-03-08	12	Pick up	t
8	3	10	2022-01-09	2022-03-09	12	Deliver to house	f
9	7	3	2022-01-09	2022-03-09	12	Pick up	f
10	7	3	2022-01-09	2022-03-09	12	Deliver to house	t
7	6	4	2022-01-09	2022-03-09	12	Pick up	t
6	6	15	2022-01-09	2022-03-09	12	Deliver to house	t
\.


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parent (student_id, first_name, last_name, person_number, phone_number, email_addr) FROM stdin;
\.


--
-- Data for Name: siblings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.siblings (id, student_id, sibling_id) FROM stdin;
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock (instrument_id, instruments_quantity) FROM stdin;
9	3
5	18
8	12
4	11
2	2
1	3
3	2
7	2
6	18
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (id, first_name, last_name, person_number, street, city, zip_code, sibling, rented_instrument_amount) FROM stdin;
1	Alexandre	Pollard	19760812-8999	UpperStreet	Stockholm	29095	yes	0
7	Aine	Stuart	19980507-3910	DrummondLas	Kista	74534	No	0
8	Matilda	Crouch	19990809-9219	HoustounRoadWest	Huddinge	26180	No	0
11	Fabien	Buck	19830721-1852	NenePark	Tullinge	53710	No	0
13	Mea	Bell	19970214-0585	HerefordStreet	Södertälje	4838	yes	0
16	Anja	Meyer	20011128-4652	MooreGround	Stockholm	5098	yes	0
17	Aya	Irvine	19960826-3057	StAlbansPastures	Stockholm	22156	No	0
19	Hana	Michael	20060713-5700	EmpressEsplanade	Kista	88913	No	0
20	Bessie	Sims	20010201-7804	ChaffinchCorner	Upplands Väsby	1677	No	0
21	Milan	Rivera	19790221-7164	BaronNorth	Tumba	47204	No	0
22	Aiza	Draper	20050512-3605	MoorlandMoorings	Upplands Väsby	60675	No	0
23	Anais	Simon	19971114-1195	RodneyRoad	Stockholm	37938	No	0
24	Lainey	Osborne	20031222-3689	BackCrownStreet	Södertälje	21242	yes	0
25	Frances	Hobbs	20060426-6752	SouthwoodDrove	Tullinge	21510	No	0
26	Jameel	Harrison	20050324-9855	BriarwoodGait	Södertälje	86921	No	0
27	Kris	Kline	19801006-2644	EmpressBroadway	Stockholm	41786	No	0
28	Henri	Garrison	19980120-2333	HamptonOak	Upplands Väsby	80782	No	0
29	Kasim	Hodges	20040423-5311	OakFieldAvenue	Stockholm	41671	yes	0
30	Samara	Keller	19970807-8969	WensleyGlade	Tullinge	41906	No	0
5	Zena	Huffman	19780725-7848	FurnessOak	Solna	47543	No	0
6	Keely	Roberts	20050121-1305	KeeneRoad	Upplands Väsby	33771	yes	0
18	Wendy	Alston	19901109-2084	BeestonGround	Södertälje	98494	No	0
14	Mahi	Andrade	19861120-3578	BentleyLink	Tumba	92070	No	0
9	Alicja	Rodrigues	19820226-1906	HowardGrove	Tullinge	19153	No	2
2	Alan	Wiley	19771020-7579	RannochCourt	Södertälje	62856	No	1
12	Pooja	Ashton	20050902-7022	StLeonardsView	Sollentuna	52467	yes	0
10	Jolie	Gilliam	20020726-3696	AstonWoods	Tumba	77533	No	1
3	Sarah	Andersson	20020603-3610	PretoriaChase	Tumba	15080	No	2
4	Safwan	Houghton	20020314-5306	GranaryBanks	Sollentuna	87693	No	0
15	Francesca	Yang	19781127-5112	BeaconsfieldLoke	Upplands Väsby	64381	No	1
\.


--
-- Data for Name: student_application; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_application (id, student_id, enrollment_date) FROM stdin;
\.


--
-- Data for Name: student_contact_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_contact_info (student_id, phone_number, email_addr) FROM stdin;
\.


--
-- Data for Name: student_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_payment (id, student_id, individual_lessons_amount, advanced_lessons_amount, ensembles_amount, group_lessons_amount, payment_date, intermediate_less_amount, beginner_less_amount, previous_month_charge) FROM stdin;
\.


--
-- Name: adminstrator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adminstrator_id_seq', 1, false);


--
-- Name: audition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audition_id_seq', 1, false);


--
-- Name: ensemble_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ensemble_id_seq', 12, true);


--
-- Name: group_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_lesson_id_seq', 11, true);


--
-- Name: individual_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.individual_lesson_id_seq', 16, true);


--
-- Name: instructor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instructor_id_seq', 14, true);


--
-- Name: instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_id_seq', 9, true);


--
-- Name: instrument_rental_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_rental_id_seq', 10, true);


--
-- Name: student_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_application_id_seq', 1, false);


--
-- Name: student_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_payment_id_seq', 1, false);


--
-- Name: student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_student_id_seq', 30, true);


--
-- Name: adminstrator adminstrator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adminstrator
    ADD CONSTRAINT adminstrator_pkey PRIMARY KEY (id);


--
-- Name: audition audition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audition
    ADD CONSTRAINT audition_pkey PRIMARY KEY (id);


--
-- Name: ensemble ensemble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_pkey PRIMARY KEY (id);


--
-- Name: group_lesson group_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT group_lesson_pkey PRIMARY KEY (id);


--
-- Name: individual_lesson individual_lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT individual_lesson_pkey PRIMARY KEY (id);


--
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (id);


--
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (id);


--
-- Name: instrument_rental instrument_rental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_pkey PRIMARY KEY (id);


--
-- Name: siblings siblings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT siblings_pkey PRIMARY KEY (id);


--
-- Name: stock stock_instrument_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_instrument_id_key UNIQUE (instrument_id);


--
-- Name: student_application student_application_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_application
    ADD CONSTRAINT student_application_pkey PRIMARY KEY (id);


--
-- Name: student_contact_info student_contact_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_info
    ADD CONSTRAINT student_contact_info_pkey PRIMARY KEY (student_id);


--
-- Name: student student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_id_key UNIQUE (id);


--
-- Name: student_payment student_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_payment
    ADD CONSTRAINT student_payment_pkey PRIMARY KEY (id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: instructor_tot_given_less _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.instructor_tot_given_less AS
 SELECT instructor.first_name,
    ((count(gr_res.id) + count(ind_res.id)) + count(ens_res.id)) AS instructor_tot_lessons
   FROM (((public.instructor
     LEFT JOIN ( SELECT group_lesson.id,
            group_lesson.start_date,
            group_lesson.instructor_id,
            group_lesson.min_number_of_students,
            group_lesson.max_number_of_students,
            group_lesson.number_of_students,
            group_lesson.instrument_kind
           FROM public.group_lesson) gr_res ON (((EXTRACT(month FROM gr_res.start_date) = EXTRACT(month FROM CURRENT_DATE)) AND (EXTRACT(year FROM gr_res.start_date) = EXTRACT(year FROM CURRENT_DATE)) AND (gr_res.instructor_id = instructor.id))))
     LEFT JOIN ( SELECT individual_lesson.id,
            individual_lesson.instructor_id,
            individual_lesson.instrument_kind,
            individual_lesson.particular_level,
            individual_lesson.start_date,
            individual_lesson.student_id,
            individual_lesson.price
           FROM public.individual_lesson) ind_res ON (((EXTRACT(month FROM ind_res.start_date) = EXTRACT(month FROM CURRENT_DATE)) AND (EXTRACT(year FROM ind_res.start_date) = EXTRACT(year FROM CURRENT_DATE)) AND (ind_res.instructor_id = instructor.id))))
     LEFT JOIN ( SELECT ensemble.id,
            ensemble.genre,
            ensemble.instructor_id,
            ensemble.min_number_of_students,
            ensemble.max_number_of_students,
            ensemble.particular_level,
            ensemble.start_date,
            ensemble.number_of_student,
            ensemble.price
           FROM public.ensemble) ens_res ON (((EXTRACT(month FROM ens_res.start_date) = EXTRACT(month FROM CURRENT_DATE)) AND (EXTRACT(year FROM ens_res.start_date) = EXTRACT(year FROM CURRENT_DATE)) AND (ens_res.instructor_id = instructor.id))))
  GROUP BY instructor.id
 HAVING (((count(gr_res.id) + count(ind_res.id)) + count(ens_res.id)) > 0)
  ORDER BY ((count(gr_res.id) + count(ind_res.id)) + count(ens_res.id)) DESC;


--
-- Name: ensemble ensemble_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) ON DELETE CASCADE;


--
-- Name: instructor_contact_info instructor_contact_info_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_contact_info
    ADD CONSTRAINT instructor_contact_info_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) ON DELETE CASCADE;


--
-- Name: audition instructor_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audition
    ADD CONSTRAINT instructor_id FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- Name: individual_lesson instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- Name: group_lesson instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_lesson
    ADD CONSTRAINT instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) NOT VALID;


--
-- Name: instructor_payment instructor_payment_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_payment
    ADD CONSTRAINT instructor_payment_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- Name: stock instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(id);


--
-- Name: instrument_rental instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(id) NOT VALID;


--
-- Name: siblings sibling_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT sibling_id_fkey FOREIGN KEY (sibling_id) REFERENCES public.student(id);


--
-- Name: student_application student_application_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_application
    ADD CONSTRAINT student_application_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: student_contact_info student_contact_info_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_info
    ADD CONSTRAINT student_contact_info_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE NOT VALID;


--
-- Name: parent student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent
    ADD CONSTRAINT student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE;


--
-- Name: siblings student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: individual_lesson student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.individual_lesson
    ADD CONSTRAINT student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: instrument_rental student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) NOT VALID;


--
-- Name: student_payment student_payment_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_payment
    ADD CONSTRAINT student_payment_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: avg_lessons_per_month; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.avg_lessons_per_month;


--
-- Name: lessons_per_month; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.lessons_per_month;


--
-- PostgreSQL database dump complete
--

