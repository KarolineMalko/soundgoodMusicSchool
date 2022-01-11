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
-- PostgreSQL database dump complete
--

