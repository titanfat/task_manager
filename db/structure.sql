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

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'user',
    'executor',
    'editor'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sprints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sprints (
    id bigint NOT NULL,
    start_date date DEFAULT '2024-12-16'::date NOT NULL,
    end_date date DEFAULT '2024-12-30'::date NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: sprints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sprints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sprints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sprints_id_seq OWNED BY public.sprints.id;


--
-- Name: sprints_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sprints_users (
    sprint_id bigint NOT NULL,
    user_id bigint NOT NULL
);


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    title character varying NOT NULL,
    body text,
    status character varying NOT NULL,
    author_id bigint NOT NULL,
    executor_id bigint,
    lead_time integer,
    start_date date,
    end_date date,
    project_id bigint NOT NULL,
    sprint_id bigint,
    description text,
    history jsonb DEFAULT '{}'::jsonb NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    provider character varying DEFAULT 'email'::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    allow_password_change boolean DEFAULT false,
    remember_created_at timestamp(6) without time zone,
    confirmation_token character varying,
    confirmed_at timestamp(6) without time zone,
    confirmation_sent_at timestamp(6) without time zone,
    unconfirmed_email character varying,
    name character varying,
    nickname character varying,
    email character varying,
    first_name character varying,
    last_name character varying,
    tokens json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    project_id bigint NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: sprints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sprints ALTER COLUMN id SET DEFAULT nextval('public.sprints_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sprints sprints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sprints
    ADD CONSTRAINT sprints_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_projects_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_projects_on_name ON public.projects USING btree (name);


--
-- Name: index_sprints_on_settings; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sprints_on_settings ON public.sprints USING gin (settings);


--
-- Name: index_sprints_users_on_sprint_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sprints_users_on_sprint_id_and_user_id ON public.sprints_users USING btree (sprint_id, user_id);


--
-- Name: index_sprints_users_on_user_id_and_sprint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sprints_users_on_user_id_and_sprint_id ON public.sprints_users USING btree (user_id, sprint_id);


--
-- Name: index_tasks_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_author_id ON public.tasks USING btree (author_id);


--
-- Name: index_tasks_on_executor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_executor_id ON public.tasks USING btree (executor_id);


--
-- Name: index_tasks_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_project_id ON public.tasks USING btree (project_id);


--
-- Name: index_tasks_on_sprint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_sprint_id ON public.tasks USING btree (sprint_id);


--
-- Name: index_tasks_on_status_and_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_status_and_priority ON public.tasks USING btree (status, priority);


--
-- Name: index_tasks_on_status_and_priority_and_executor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_status_and_priority_and_executor_id ON public.tasks USING btree (status, priority, executor_id);


--
-- Name: index_tasks_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_tags ON public.tasks USING gin (tags);


--
-- Name: index_tasks_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tasks_on_title ON public.tasks USING btree (title);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_first_name_and_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_first_name_and_last_name ON public.users USING btree (first_name, last_name);


--
-- Name: index_users_on_nickname; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_nickname ON public.users USING btree (nickname);


--
-- Name: index_users_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_project_id ON public.users USING btree (project_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_uid ON public.users USING btree (uid);


--
-- Name: index_users_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_uid_and_provider ON public.users USING btree (uid, provider);


--
-- Name: tasks fk_rails_02e851e3b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_02e851e3b7 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: tasks fk_rails_591cb42199; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_591cb42199 FOREIGN KEY (sprint_id) REFERENCES public.sprints(id);


--
-- Name: tasks fk_rails_799f6287fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_799f6287fc FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: tasks fk_rails_9b698982dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_9b698982dd FOREIGN KEY (executor_id) REFERENCES public.users(id);


--
-- Name: sprints_users fk_rails_c110d37e7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sprints_users
    ADD CONSTRAINT fk_rails_c110d37e7b FOREIGN KEY (sprint_id) REFERENCES public.sprints(id) ON DELETE CASCADE;


--
-- Name: sprints_users fk_rails_d51bae205b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sprints_users
    ADD CONSTRAINT fk_rails_d51bae205b FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users fk_rails_fedc809cf8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_fedc809cf8 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20241216210617'),
('20241216210610'),
('20241216210554'),
('20241216205750'),
('20241215022931'),
('20241215022249'),
('20241215021953'),
('20241215021559'),
('20241213223624'),
('20241130174951');

