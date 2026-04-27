--
-- PostgreSQL database dump
--

\restrict tHvl6KMbFPHyqDJof8WkDv4QZRkcfyIiMEJ0KYJ0VKhoX7R0nqw4qWwfa7M0Tbg

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

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
-- Name: azure_alerts; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.azure_alerts (
    id bigint NOT NULL,
    alert_name character varying(255),
    azure_alert_id character varying(255),
    description character varying(255),
    metric_name character varying(255),
    metric_namespace character varying(255),
    metric_value double precision,
    occurred_at timestamp(6) without time zone,
    operator character varying(255),
    severity character varying(255),
    threshold double precision,
    vm_id bigint NOT NULL,
    alert_rule character varying(255),
    correlation_id character varying(255),
    duration_seconds bigint,
    fired_alert_id bigint,
    monitor_condition character varying(255),
    resolved_at timestamp(6) without time zone,
    fired_at timestamp(6) without time zone
);


ALTER TABLE public.azure_alerts OWNER TO znaidi;

--
-- Name: azure_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.azure_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.azure_alerts_id_seq OWNER TO znaidi;

--
-- Name: azure_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.azure_alerts_id_seq OWNED BY public.azure_alerts.id;


--
-- Name: blacklisted_tokens; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.blacklisted_tokens (
    id bigint NOT NULL,
    blacklisted_at timestamp(6) without time zone NOT NULL,
    token character varying(1000) NOT NULL
);


ALTER TABLE public.blacklisted_tokens OWNER TO znaidi;

--
-- Name: blacklisted_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.blacklisted_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.blacklisted_tokens_id_seq OWNER TO znaidi;

--
-- Name: blacklisted_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.blacklisted_tokens_id_seq OWNED BY public.blacklisted_tokens.id;


--
-- Name: cost_records; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.cost_records (
    id bigint NOT NULL,
    amount double precision,
    cost_type character varying(255),
    currency character varying(255),
    date date,
    vm_id bigint NOT NULL,
    CONSTRAINT cost_records_cost_type_check CHECK (((cost_type)::text = ANY ((ARRAY['COMPUTE'::character varying, 'DISK'::character varying, 'BACKUP'::character varying, 'PUBLIC_IP'::character varying, 'STORAGE'::character varying, 'NETWORK'::character varying, 'OTHER'::character varying])::text[])))
);


ALTER TABLE public.cost_records OWNER TO znaidi;

--
-- Name: cost_records_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.cost_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cost_records_id_seq OWNER TO znaidi;

--
-- Name: cost_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.cost_records_id_seq OWNED BY public.cost_records.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.invoices (
    id bigint NOT NULL,
    amount_due double precision,
    billing_period_end timestamp(6) without time zone,
    billing_period_start timestamp(6) without time zone,
    currency character varying(255),
    download_url character varying(255),
    due_date timestamp(6) without time zone,
    invoice_date timestamp(6) without time zone,
    invoice_id character varying(255) NOT NULL,
    invoice_name character varying(255),
    status character varying(255),
    total_amount double precision
);


ALTER TABLE public.invoices OWNER TO znaidi;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoices_id_seq OWNER TO znaidi;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: monthly_costs; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.monthly_costs (
    id bigint NOT NULL,
    cost numeric(38,15) NOT NULL,
    currency character varying(10),
    is_shared boolean,
    meter_name character varying(500) NOT NULL,
    month integer NOT NULL,
    resource_category character varying(50),
    service_name character varying(200) NOT NULL,
    synced_at timestamp(6) without time zone,
    vm_id bigint,
    year integer NOT NULL
);


ALTER TABLE public.monthly_costs OWNER TO znaidi;

--
-- Name: monthly_costs_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.monthly_costs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monthly_costs_id_seq OWNER TO znaidi;

--
-- Name: monthly_costs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.monthly_costs_id_seq OWNED BY public.monthly_costs.id;


--
-- Name: monthly_vm_costs; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.monthly_vm_costs (
    id bigint NOT NULL,
    availability_percent double precision,
    calculated_at timestamp(6) without time zone,
    direct_cost numeric(38,15) NOT NULL,
    month integer NOT NULL,
    reservation_cost numeric(38,15) NOT NULL,
    shared_cost numeric(38,15) NOT NULL,
    total_cost numeric(38,15) NOT NULL,
    year integer NOT NULL,
    vm_id bigint NOT NULL
);


ALTER TABLE public.monthly_vm_costs OWNER TO znaidi;

--
-- Name: monthly_vm_costs_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.monthly_vm_costs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monthly_vm_costs_id_seq OWNER TO znaidi;

--
-- Name: monthly_vm_costs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.monthly_vm_costs_id_seq OWNED BY public.monthly_vm_costs.id;


--
-- Name: performance_metrics; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.performance_metrics (
    id bigint NOT NULL,
    availability_percent double precision,
    cpu_avg double precision,
    cpu_max double precision,
    cpu_min double precision,
    disk_avg double precision,
    disk_max double precision,
    disk_min double precision,
    ram_avg double precision,
    ram_max double precision,
    ram_min double precision,
    saved_at timestamp(6) without time zone,
    vm_id bigint NOT NULL,
    disk_read double precision,
    disk_write double precision,
    network_in double precision,
    network_out double precision
);


ALTER TABLE public.performance_metrics OWNER TO znaidi;

--
-- Name: performance_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.performance_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.performance_metrics_id_seq OWNER TO znaidi;

--
-- Name: performance_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.performance_metrics_id_seq OWNED BY public.performance_metrics.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.reservations (
    reservation_id character varying(255) NOT NULL,
    display_name character varying(255) NOT NULL,
    expiry_date_time timestamp(6) with time zone NOT NULL,
    purchase_date_time timestamp(6) with time zone NOT NULL,
    synced_at timestamp(6) without time zone NOT NULL,
    vm_type character varying(255) NOT NULL
);


ALTER TABLE public.reservations OWNER TO znaidi;

--
-- Name: scheduler_config; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.scheduler_config (
    task_name character varying(255) NOT NULL,
    cron_expression character varying(255),
    last_execution timestamp(6) without time zone,
    last_status character varying(255)
);


ALTER TABLE public.scheduler_config OWNER TO znaidi;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.tags OWNER TO znaidi;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tags_id_seq OWNER TO znaidi;

--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    otp_code character varying(255),
    otp_expiry timestamp(6) without time zone,
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['SUPER_ADMIN'::character varying, 'MANAGER'::character varying, 'TECHNICAL'::character varying, 'FINANCE'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO znaidi;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO znaidi;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vm_tag; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.vm_tag (
    vm_id bigint NOT NULL,
    tag_id bigint NOT NULL
);


ALTER TABLE public.vm_tag OWNER TO znaidi;

--
-- Name: vms; Type: TABLE; Schema: public; Owner: znaidi
--

CREATE TABLE public.vms (
    id bigint NOT NULL,
    azure_vm_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    region character varying(255),
    resource_group character varying(255),
    status character varying(255),
    vm_type character varying(255),
    billing_type character varying(255),
    domain_name character varying(255),
    public_ip_address character varying(255),
    CONSTRAINT vms_billing_type_check CHECK (((billing_type)::text = ANY ((ARRAY['RESERVATION'::character varying, 'PAYG'::character varying])::text[])))
);


ALTER TABLE public.vms OWNER TO znaidi;

--
-- Name: vms_id_seq; Type: SEQUENCE; Schema: public; Owner: znaidi
--

CREATE SEQUENCE public.vms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vms_id_seq OWNER TO znaidi;

--
-- Name: vms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: znaidi
--

ALTER SEQUENCE public.vms_id_seq OWNED BY public.vms.id;


--
-- Name: azure_alerts id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.azure_alerts ALTER COLUMN id SET DEFAULT nextval('public.azure_alerts_id_seq'::regclass);


--
-- Name: blacklisted_tokens id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.blacklisted_tokens ALTER COLUMN id SET DEFAULT nextval('public.blacklisted_tokens_id_seq'::regclass);


--
-- Name: cost_records id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.cost_records ALTER COLUMN id SET DEFAULT nextval('public.cost_records_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: monthly_costs id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.monthly_costs ALTER COLUMN id SET DEFAULT nextval('public.monthly_costs_id_seq'::regclass);


--
-- Name: monthly_vm_costs id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.monthly_vm_costs ALTER COLUMN id SET DEFAULT nextval('public.monthly_vm_costs_id_seq'::regclass);


--
-- Name: performance_metrics id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.performance_metrics ALTER COLUMN id SET DEFAULT nextval('public.performance_metrics_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vms id; Type: DEFAULT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.vms ALTER COLUMN id SET DEFAULT nextval('public.vms_id_seq'::regclass);


--
-- Data for Name: azure_alerts; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.azure_alerts (id, alert_name, azure_alert_id, description, metric_name, metric_namespace, metric_value, occurred_at, operator, severity, threshold, vm_id, alert_rule, correlation_id, duration_seconds, fired_alert_id, monitor_condition, resolved_at, fired_at) FROM stdin;
216	[Sindibadgroup] Low RAM available	76df7a43-2081-46dd-8bc1-ca32c991f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-15 14:38:57.236064	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	0	\N	Resolved	2026-04-15 14:38:57.236064	2026-04-15 14:38:57.236064
217	[Sindibadgroup] Low RAM available	641e2e1b-193c-4d11-bf80-a73c2b84f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-16 11:18:49.994169	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	0	\N	Resolved	2026-04-16 11:18:49.994169	2026-04-16 11:18:49.994169
218	[Sindibadgroup] Low RAM available	38072f36-f02f-4c82-add4-629911b3f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-20 14:33:38.103495	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	0	\N	Resolved	2026-04-20 14:33:38.103495	2026-04-20 14:33:38.103495
219	[Sindibadgroup] Low RAM available	50037458-a4a8-4094-8433-a201e299f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-22 07:48:39.037124	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	0	\N	Resolved	2026-04-22 07:48:39.037124	2026-04-22 07:48:39.037124
221	[Sindibadgroup] High CPU Usage	853d66b5-8415-4cd9-b970-9517c790f000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-04-23 14:10:27.074712	GreaterThan	Sev2	90	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-04-23 14:10:27.074712	\N
220	[Sindibadgroup] Low RAM available	929c17ac-14ff-46e8-aed6-fc900b2cf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-23 11:24:20.616786	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	0	\N	Resolved	2026-04-23 11:24:20.616786	2026-04-23 11:24:20.616786
222	[Sindibadgroup] Low RAM available	e00c56f1-2b13-49d2-b4e1-7595e10bf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-26 06:34:23.527552	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-26 06:34:23.527552	\N
223	[Sindibadgroup] Low RAM available	462dec56-1097-4625-b753-ee742d07f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-26 14:49:19.545772	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	0	\N	Resolved	2026-04-26 14:49:19.545772	2026-04-26 14:49:19.545772
164	[Sindibadgroup] Low RAM available	412a5bc2-ab0e-48d6-950e-f4fb351df000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-13 17:05:06.111175	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-13 17:05:06.111175	\N
165	[Sindibadgroup] Low RAM available	17efa9d0-5ec0-40fa-a41f-9b265d0ef000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-13 03:09:52.230544	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-13 03:09:52.230544	\N
166	[Sindibadgroup] Low RAM available	fcd66c3d-7d6f-4882-ad50-ef6b8494f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-13 01:59:46.185315	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-13 01:59:46.185315	\N
167	[Sindibadgroup] Low RAM available	152fd52a-f908-43cd-a38e-ff47279cf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-13 00:54:48.040472	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-13 00:54:48.040472	\N
168	[Sindibadgroup] Low RAM available	47688707-4ae8-4a51-9349-a972650df000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-13 00:04:50.684825	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-13 00:04:50.684825	\N
169	[Sindibadgroup] Low RAM available	264ed333-ceb2-43ca-aa31-ae2756e8f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-12 19:49:41.298247	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-12 19:49:41.298247	\N
170	[Sindibadgroup] Low RAM available	fea2776e-11f6-4ae7-9a5f-7655e373f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-12 19:19:45.002102	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-12 19:19:45.002102	\N
171	[Sindibadgroup] Low RAM available	3baf5ba2-244f-4803-a32f-ea49351ff000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-12 17:54:42.266483	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-12 17:54:42.266483	\N
172	[Sindibadgroup] Low RAM available	37cfe153-c3e9-4f0c-b5e9-bdeb8789f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-12 16:34:43.368188	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-12 16:34:43.368188	\N
173	[Sindibadgroup] Low RAM available	d6940742-b687-4f5b-999a-fd73e6f3f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-12 14:09:49.143737	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-12 14:09:49.143737	\N
174	[Sindibadgroup] Low RAM available	253c99bb-e45b-4e0b-9911-086cd91cf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-12 13:34:48.313814	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-12 13:34:48.313814	\N
175	[Sindibadgroup] Low RAM available	5f5a95bb-d1c0-4984-86d5-4d1b915bf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-12 12:24:43.630354	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-12 12:24:43.630354	\N
176	[Sindibadgroup] Low RAM available	d45c18f4-eda7-4d46-a6bd-da3b7cc8f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-10 16:29:36.927034	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-10 16:29:36.927034	\N
177	[Sindibadgroup] Low RAM available	995e1eb2-7d02-406e-8249-731808c5f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-03 16:34:31.644908	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-03 16:34:31.644908	\N
178	[Sindibadgroup] Low RAM available	ef993aad-a5bf-4092-9501-7be77a6bf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-03 14:44:40.959122	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-03 14:44:40.959122	\N
179	[Sindibadgroup] Low RAM available	c80e2b00-e048-4054-8185-b16ebc7ef000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-04-03 13:19:37.333285	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-04-03 13:19:37.333285	\N
180	[Sindibadgroup] High CPU Usage	a0553a6c-348f-4358-96b6-7d23952af000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-04-02 17:04:39.357696	GreaterThan	Sev2	90	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-04-02 17:04:39.357696	\N
181	[Sindibadgroup] High CPU Usage	d2e77063-50c1-49b1-b215-b355c148f000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-04-02 13:52:50.991893	GreaterThan	Sev2	90	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-04-02 13:52:50.991893	\N
182	[Sindibadgroup] High CPU Usage	7a83e710-8b88-4aa6-b71d-149f5a6ff000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-31 23:04:27.72518	GreaterThan	Sev2	90	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-31 23:04:27.72518	\N
183	[Sindibadgroup] Low RAM available	6c6a5c05-9789-4092-b821-e81a0b0df000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-30 14:24:15.982628	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-30 14:24:15.982628	\N
184	[Sindibadgroup] Low RAM available	ead17fab-f567-4f8a-b0f0-a47ebc33f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-30 05:55:35.748743	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-30 05:55:35.748743	\N
185	[Sindibadgroup] Low RAM available	a19e3096-4d13-4a2b-9626-9ff2208df000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-30 05:24:11.912143	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-30 05:24:11.912143	\N
186	[Sindibadgroup] Low RAM available	5458af9f-7275-4234-9ade-e1fa4655f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-29 23:49:12.074401	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-29 23:49:12.074401	\N
187	[Sindibadgroup] Low RAM available	3a216281-5d20-4196-9447-a489f578f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-29 21:50:34.920235	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-29 21:50:34.920235	\N
188	[Sindibadgroup] Low RAM available	3a190dfb-7635-4a3f-9acf-26720fcdf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-29 19:35:33.258627	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-29 19:35:33.258627	\N
189	[Sindibadgroup] Low RAM available	ee800bba-b158-4995-8bc5-1286046ef000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-29 15:51:01.150679	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-29 15:51:01.150679	\N
190	[Sindibadgroup] Low RAM available	5def1d79-8220-43c4-889b-8ee9189ff000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-29 12:59:11.976832	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-29 12:59:11.976832	\N
191	[Sindibadgroup] Low RAM available	4147cf86-2161-4218-82a5-ded2f58ef000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-29 08:14:06.892617	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-29 08:14:06.892617	\N
192	[Sindibadgroup] Low RAM available	b20327b8-681a-41c0-af0a-de106b1bf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-29 07:39:08.269184	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-29 07:39:08.269184	\N
193	[Sindibadgroup] Low RAM available	627de315-9f8b-4559-86b0-75a2877ff000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-26 10:54:01.250424	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-26 10:54:01.250424	\N
194	[Sindibadgroup] Low RAM available	c2d21f33-4ca0-4bdb-9b2b-1f0bc1caf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-24 14:40:52.670451	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-24 14:40:52.670451	\N
195	[Sindibadgroup] Low RAM available	e6a3fa52-bb8a-4b81-9b82-ce2cbdeff000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-24 05:56:01.474543	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-24 05:56:01.474543	\N
196	[Sindibadgroup] Low RAM available	a60e3161-ee28-4ff9-94fa-4047087ff000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-23 15:45:20.611651	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-23 15:45:20.611651	\N
197	[Sindibadgroup] Low RAM available	14cfb265-074a-4d95-8c20-314d8c9af000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-23 14:05:21.52989	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-23 14:05:21.52989	\N
198	[Sindibadgroup] Low RAM available	1a3cc043-ca12-4053-adba-ab2e29b6f000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-21 12:02:26.817229	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-21 12:02:26.817229	\N
199	[Sindibadgroup] Low RAM available	a15e573d-1d81-413c-b20d-eaa7d4dff000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-17 03:49:11.170437	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-17 03:49:11.170437	\N
200	[Sindibadgroup] Low RAM available	bb6ce0b0-aca8-4e57-b16a-977531fbf000	Detect low RAM available (Less than 1 GB) of VM machines	Available Memory Bytes	microsoft.compute/virtualmachines	\N	2026-03-16 23:24:33.479765	LessThan	Sev2	1000000000	3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] Low RAM available	\N	\N	\N	Resolved	2026-03-16 23:24:33.479765	\N
201	[Sindibadgroup] VM not available	7ff9f6fd-943d-4481-b0d6-2b8162e6f000	Detect VM machines availability	VmAvailabilityMetric	microsoft.compute/virtualmachines	\N	2026-03-31 17:49:07.512171	LessThan	Sev2	1	5	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] VM not available	\N	\N	\N	Resolved	2026-03-31 17:49:07.512171	\N
202	[Sindibadgroup] High CPU Usage	e776456f-1c6d-4be5-abf4-fb0ce72df000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-23 11:42:10.041998	GreaterThan	Sev2	90	5	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-23 11:42:10.041998	\N
203	[Sindibadgroup] VM not available	fdb5dcd0-1302-46d0-af54-9f6942e0f000	Detect VM machines availability	VmAvailabilityMetric	microsoft.compute/virtualmachines	\N	2026-03-17 06:05:48.291607	LessThan	Sev2	1	5	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] VM not available	\N	\N	\N	Resolved	2026-03-17 06:05:48.291607	\N
204	[Sindibadgroup] High CPU Usage	d60b4a93-45ea-4e94-8292-da6bce6cf000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-23 11:22:16.490475	GreaterThan	Sev2	90	6	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-23 11:22:16.490475	\N
205	[Sindibadgroup] High CPU Usage	9525ff20-0cf6-4317-bef0-3c0452f2f000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-23 11:58:25.344268	GreaterThan	Sev2	90	7	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-23 11:58:25.344268	\N
206	[Sindibadgroup] High CPU Usage	e7abd339-21d4-4c3c-b517-5b594139f000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-23 11:52:09.750556	GreaterThan	Sev2	90	1	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-23 11:52:09.750556	\N
207	[Sindibadgroup] High CPU Usage	4b8ccf6c-7a8b-4cfe-9476-62f4beacf000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-04-10 15:07:41.849671	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-04-10 15:07:41.849671	\N
208	[Sindibadgroup] High CPU Usage	1da574dd-d2c6-4f1b-ba88-abca485df000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-04-09 21:35:26.915896	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-04-09 21:35:26.915896	\N
209	[Sindibadgroup] High CPU Usage	74bc9881-2fbe-4915-8e26-dcd5f93bf000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-04-09 12:52:33.350279	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-04-09 12:52:33.350279	\N
210	[Sindibadgroup] High CPU Usage	c034f6c7-14c3-4838-bfa0-5c444efff000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-04-09 09:47:34.135628	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-04-09 09:47:34.135628	\N
211	[Sindibadgroup] High CPU Usage	31b04098-1cd8-4afb-8cd9-e4d8686df000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-04-04 10:49:47.306735	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-04-04 10:49:47.306735	\N
212	[Sindibadgroup] High CPU Usage	64b3a9d5-f1ea-4a4f-9168-986e1022f000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-24 19:08:43.183193	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-24 19:08:43.183193	\N
213	[Sindibadgroup] High CPU Usage	7b9e4997-2f8d-4e81-9d09-2b99d5fcf000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-23 11:37:20.027958	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-23 11:37:20.027958	\N
214	[Sindibadgroup] High CPU Usage	1e285e6d-e5b4-485d-8b43-18ca1a5ff000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-18 08:46:53.168563	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-18 08:46:53.168563	\N
215	[Sindibadgroup] High CPU Usage	e1ca952a-11d1-4c6b-a5b1-4582779df000	Detect High CPU usage (More than 90%) of VM machines	Percentage CPU	microsoft.compute/virtualmachines	\N	2026-03-17 00:41:48.083571	GreaterThan	Sev2	90	4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/rg-leoni-prod/providers/microsoft.insights/metricAlerts/[Sindibadgroup] High CPU Usage	\N	\N	\N	Resolved	2026-03-17 00:41:48.083571	\N
\.


--
-- Data for Name: blacklisted_tokens; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.blacklisted_tokens (id, blacklisted_at, token) FROM stdin;
\.


--
-- Data for Name: cost_records; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.cost_records (id, amount, cost_type, currency, date, vm_id) FROM stdin;
48	0.2491832	DISK	USD	2026-03-31	1
49	0.1161216	DISK	USD	2026-03-31	2
50	0.214	DISK	USD	2026-03-31	3
51	0.2810646	DISK	USD	2026-03-31	4
52	0.1618834	DISK	USD	2026-03-31	7
53	0.1766848	DISK	USD	2026-03-31	6
54	1.11065194	COMPUTE	USD	2026-03-31	7
55	0.12	PUBLIC_IP	USD	2026-03-31	2
56	0.12	PUBLIC_IP	USD	2026-03-31	3
57	0.12	PUBLIC_IP	USD	2026-03-31	4
58	0.12	PUBLIC_IP	USD	2026-03-31	5
59	0.12	PUBLIC_IP	USD	2026-03-31	6
60	0.51510892069	OTHER	USD	2026-03-31	4
61	0.15833661311	OTHER	USD	2026-03-31	6
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.invoices (id, amount_due, billing_period_end, billing_period_start, currency, download_url, due_date, invoice_date, invoice_id, invoice_name, status, total_amount) FROM stdin;
13	0	2025-04-01 00:00:00	2025-03-01 00:00:00	USD	\N	2025-04-09 01:07:56.538063	2025-04-09 01:07:50.709874	G086035343	\N	Paid	376.41
14	0	2025-05-01 00:00:00	2025-04-01 00:00:00	USD	\N	2025-05-09 04:18:43.964933	2025-05-09 04:18:42.199268	G091608126	\N	Paid	366.01
15	0	2025-06-01 00:00:00	2025-05-01 00:00:00	USD	\N	2025-06-09 03:10:21.692504	2025-06-09 03:10:18.176826	G096207834	\N	Paid	365.55
16	0	2025-06-16 12:35:59.068743	2025-06-16 12:35:59.068743	USD	\N	2025-06-16 12:35:59.068743	2025-06-16 12:36:43.73123	G097558215	\N	Paid	47.83
17	0	2025-06-16 12:09:53.290317	2025-06-16 12:09:53.290317	USD	\N	2025-06-16 12:09:53.290317	2025-06-16 12:16:36.543649	G097558396	\N	Paid	167
18	0	2025-07-01 00:00:00	2025-06-01 00:00:00	USD	\N	2025-07-09 03:49:46.009375	2025-07-09 03:49:44.556225	G101434982	\N	Paid	150.77
19	0	2025-08-01 00:00:00	2025-07-01 00:00:00	USD	\N	2025-08-09 09:03:26.594678	2025-08-09 09:03:25.782165	G106660533	\N	Paid	372.6
20	0	2025-09-01 00:00:00	2025-08-01 00:00:00	USD	\N	2025-09-09 07:43:38.766976	2025-09-09 07:43:37.391947	G111561781	\N	Paid	332.98
21	0	2025-10-01 00:00:00	2025-09-01 00:00:00	USD	\N	2025-10-09 08:17:02.952517	2025-10-09 08:17:01.030609	G117874627	\N	Paid	394
22	0	2025-11-01 00:00:00	2025-10-01 00:00:00	USD	\N	2025-11-09 06:02:27.889944	2025-11-09 06:02:22.546142	G122621514	\N	Paid	328.26
23	0	2025-12-01 00:00:00	2025-11-01 00:00:00	USD	\N	2025-12-09 05:26:10.147698	2025-12-09 05:26:09.06955	G128460229	\N	Paid	334.03
24	0	2026-01-01 00:00:00	2025-12-01 00:00:00	USD	\N	2026-01-09 09:15:55.280149	2026-01-09 09:15:53.623868	G134499465	\N	Paid	342.66
25	0	2026-02-01 00:00:00	2026-01-01 00:00:00	USD	\N	2026-02-09 07:17:28.677518	2026-02-09 07:17:26.021205	G139640428	\N	Paid	337.99
26	0	2026-03-01 00:00:00	2026-02-01 00:00:00	USD	\N	2026-03-09 08:11:30.850545	2026-03-09 08:11:29.350521	G145729858	\N	Paid	332.05
27	0	2026-04-01 00:00:00	2026-03-01 00:00:00	USD	\N	2026-04-09 09:11:06.189537	2026-04-09 09:11:04.017617	G151899515	\N	Paid	336.76
\.


--
-- Data for Name: monthly_costs; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.monthly_costs (id, cost, currency, is_shared, meter_name, month, resource_category, service_name, synced_at, vm_id, year) FROM stdin;
3028	167.000000000000000	USD	t	[RESERVATION] D2ls v5	3	RESERVATION	Virtual Machines	2026-04-17 09:29:13.139497	\N	2026
3029	47.830000000000000	USD	t	[RESERVATION] D2s v5	3	RESERVATION	Virtual Machines	2026-04-17 09:29:13.139526	\N	2026
3030	0.299683200000000	USD	t	Snapshots LRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.139563	\N	2026
3031	0.000001400000000	USD	t	E10 ZRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139581	\N	2026
3032	0.290304000000000	USD	t	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.139587	\N	2026
3033	3.537835400000000	USD	f	E10 ZRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139595	1	2026
3034	3.599769600000000	USD	f	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.139601	1	2026
3035	0.032107400000000	USD	f	E10 ZRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139608	2	2026
3036	3.599769600000000	USD	f	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.139614	2	2026
3037	1.535901696000000	USD	f	S4 LRS Disk	3	DISK	Storage	2026-04-17 09:29:13.139636	2	2026
3038	0.021058450000000	USD	f	S4 LRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139656	2	2026
3039	3.000872800000000	USD	f	E10 ZRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139664	3	2026
3040	3.599769600000000	USD	f	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.13967	3	2026
3041	4.396537000000000	USD	f	E10 ZRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139683	4	2026
3042	3.599769600000000	USD	f	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.13969	4	2026
3043	3.599769600000000	USD	f	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.139706	4	2026
3044	1.072655400000000	USD	f	E10 ZRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139733	5	2026
3045	3.599769600000000	USD	f	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.139745	5	2026
3046	1.430071000000000	USD	f	E10 ZRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139753	7	2026
3047	3.599769600000000	USD	f	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.139759	7	2026
3048	2.079375400000000	USD	f	E10 ZRS Disk Operations	3	DISK	Storage	2026-04-17 09:29:13.139766	6	2026
3049	3.599769600000000	USD	f	E4 ZRS Disk	3	DISK	Storage	2026-04-17 09:29:13.139772	6	2026
3050	0.516373200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.139797	1	2026
3051	0.001500150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.139829	1	2026
3052	0.037166550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.13985	1	2026
3053	0.037028000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.139871	1	2026
3054	0.034048000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.139891	1	2026
3055	0.035526350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.13991	1	2026
3056	0.035699000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.13993	1	2026
3057	0.037625050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.139949	1	2026
3058	0.043608000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.13997	1	2026
3059	0.040090700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.139991	1	2026
3060	0.035407950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14001	1	2026
3061	0.032137650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140036	1	2026
3062	0.034859200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140056	1	2026
3063	0.034668850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140076	1	2026
3064	0.039165350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140096	1	2026
3065	0.087700300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140116	1	2026
3066	0.088205050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140136	1	2026
3067	0.082603700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140156	1	2026
3068	0.085996400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140176	1	2026
3069	0.135574850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140195	1	2026
3070	0.072571600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140216	1	2026
3071	0.102950700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140236	1	2026
3072	0.116321700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140257	1	2026
3073	0.115405350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140276	1	2026
3074	0.109261950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140296	1	2026
3075	0.113233650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140316	1	2026
3076	0.121324900000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140336	1	2026
3077	0.127909700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140355	1	2026
3078	0.127602200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140375	1	2026
3079	0.151346400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140395	1	2026
3080	0.166611050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140416	1	2026
3081	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140437	1	2026
3082	0.139784100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140457	1	2026
3083	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140477	1	2026
3084	0.062361050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140496	1	2026
3085	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140516	1	2026
3086	0.011518800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140536	1	2026
3087	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140556	1	2026
3088	0.012969600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140575	1	2026
3089	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140596	1	2026
3090	0.017755200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140616	1	2026
3091	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140636	1	2026
3092	0.132912000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140655	1	2026
3093	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140675	1	2026
3094	0.049050000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140694	1	2026
3095	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140714	1	2026
3096	0.010224000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140734	1	2026
3097	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140754	1	2026
3098	0.008801200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140774	1	2026
3099	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140794	1	2026
3100	0.008553600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14082	1	2026
3101	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140841	1	2026
3102	0.013406400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140859	1	2026
3103	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140877	1	2026
3104	0.041108350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140895	1	2026
3105	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140912	1	2026
3106	0.075513600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14093	1	2026
3107	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140947	1	2026
3108	0.076942200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140966	1	2026
3109	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.140983	1	2026
3110	0.059526750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141001	1	2026
3111	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141018	1	2026
3112	0.054434350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141036	1	2026
3113	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141054	1	2026
3114	0.055206000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141077	1	2026
3115	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141108	1	2026
3116	0.055440000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141136	1	2026
3117	0.000001800000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141168	1	2026
3118	0.052993200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141198	1	2026
3119	0.000002050000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141219	1	2026
3120	0.050688000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141237	1	2026
3121	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141254	1	2026
3122	0.037511800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141272	1	2026
3123	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14129	1	2026
3124	0.037269700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141307	1	2026
3125	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141327	1	2026
3126	0.033409050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141349	1	2026
3127	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141367	1	2026
3128	0.043621850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141385	1	2026
3129	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141402	1	2026
3130	0.025116000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141421	1	2026
3131	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141442	1	2026
3132	0.023126400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141469	1	2026
3133	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141488	1	2026
3134	0.023490000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141505	1	2026
3135	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141523	1	2026
3136	0.016214400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141541	1	2026
3137	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141559	1	2026
3138	0.010998000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141576	1	2026
3139	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141594	1	2026
3140	0.007528800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141612	1	2026
3141	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141629	1	2026
3142	0.003306950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141646	1	2026
3143	0.031022400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141664	1	2026
3144	0.038632550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141682	1	2026
3145	0.037838700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.1417	1	2026
3146	0.029094400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141718	1	2026
3147	0.028596750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141735	1	2026
3148	0.031628200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141753	1	2026
3149	0.031024150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14177	1	2026
3150	0.032762300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141787	1	2026
3151	0.032576700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141804	1	2026
3152	0.026142900000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14183	1	2026
3153	0.024686000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141847	1	2026
3154	0.027768700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141865	1	2026
3155	0.027993750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141883	1	2026
3156	0.032584450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141901	1	2026
3157	0.099596200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141918	1	2026
3158	0.120586250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141936	1	2026
3159	0.108495250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141953	1	2026
3160	0.114632950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141971	1	2026
3161	0.133799250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.141988	1	2026
3162	0.126491400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142006	1	2026
3163	0.138749300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142023	1	2026
3164	0.153386400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14204	1	2026
3165	0.148745450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142057	1	2026
3166	0.150918700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142075	1	2026
3167	0.155930250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142093	1	2026
3168	0.166253150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14211	1	2026
3169	0.176330050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142128	1	2026
3170	0.182481000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142146	1	2026
3171	0.191452350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142163	1	2026
3172	0.209601700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14218	1	2026
3173	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142199	1	2026
3174	0.195792150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14222	1	2026
3175	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142238	1	2026
3176	0.020746750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142255	1	2026
3177	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142273	1	2026
3178	0.013467600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142291	1	2026
3179	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142308	1	2026
3180	0.014414400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142326	1	2026
3181	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142344	1	2026
3182	0.020120400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142362	1	2026
3183	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142381	1	2026
3184	0.021465600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142398	1	2026
3185	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142416	1	2026
3186	0.021710400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142434	1	2026
3187	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142452	1	2026
3188	0.018726900000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142469	1	2026
3189	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142486	1	2026
3190	0.010110850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142503	1	2026
3191	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142521	1	2026
3192	0.012068300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142538	1	2026
3193	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142557	1	2026
3194	0.014691600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142575	1	2026
3195	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142592	1	2026
3196	0.050376000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142609	1	2026
3197	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142627	1	2026
3198	0.105948350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142645	1	2026
3199	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142662	1	2026
3200	0.105062400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14268	1	2026
3201	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142698	1	2026
3202	0.092964400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142715	1	2026
3203	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142733	1	2026
3204	0.083462400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14275	1	2026
3205	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142769	1	2026
3206	0.084652400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142786	1	2026
3207	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142804	1	2026
3208	0.076309250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142829	1	2026
3209	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142848	1	2026
3210	0.078742300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142865	1	2026
3211	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142883	1	2026
3212	0.064247950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142901	1	2026
3213	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142919	1	2026
3214	0.058885700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142936	1	2026
3215	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142954	1	2026
3216	0.055280700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142972	1	2026
3217	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.142989	1	2026
3218	0.047459600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143007	1	2026
3219	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143025	1	2026
3220	0.054711550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143042	1	2026
3221	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14306	1	2026
3222	0.041743550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143077	1	2026
3223	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143095	1	2026
3224	0.032847650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143113	1	2026
3225	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143131	1	2026
3226	0.027745050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143148	1	2026
3227	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143166	1	2026
3228	0.023438700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143183	1	2026
3229	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143201	1	2026
3230	0.017135300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143219	1	2026
3231	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143237	1	2026
3232	0.010447200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143254	1	2026
3233	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143272	1	2026
3234	0.005314800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14329	1	2026
3235	0.001200850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143308	1	2026
3236	0.028652150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143326	1	2026
3237	0.029279650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143343	1	2026
3238	0.029668200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143361	1	2026
3239	0.030622200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143379	1	2026
3240	0.031189400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143396	1	2026
3241	0.031789450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143414	1	2026
3242	0.031950800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143432	1	2026
3243	0.033199450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143449	1	2026
3244	0.032116700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143467	1	2026
3245	0.036105300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143484	1	2026
3246	0.035771750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143501	1	2026
3247	0.035713650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143519	1	2026
3248	0.035865600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143536	1	2026
3249	0.036258600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143554	1	2026
3250	0.035125550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143571	1	2026
3251	0.034683900000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143588	1	2026
3252	0.035106400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143606	1	2026
3253	0.069528750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143623	1	2026
3254	0.013184450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14364	1	2026
3255	0.042030900000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143658	1	2026
3256	0.051845300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143675	1	2026
3257	0.038318800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143692	1	2026
3258	0.037811800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143709	1	2026
3259	0.038412150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143727	1	2026
3260	0.043883300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143744	1	2026
3261	0.046616800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143762	1	2026
3262	0.045215400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143779	1	2026
3263	0.043748100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143796	1	2026
3264	0.047784100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143819	1	2026
3265	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143837	1	2026
3266	0.043746550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143854	1	2026
3267	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143873	1	2026
3268	0.039875750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143894	1	2026
3269	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143913	1	2026
3270	0.012939600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143931	1	2026
3271	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143948	1	2026
3272	0.011776050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143965	1	2026
3273	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.143984	1	2026
3274	0.018378700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144001	1	2026
3275	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144019	1	2026
3276	0.018283200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144036	1	2026
3277	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144055	1	2026
3278	0.010320000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144072	1	2026
3279	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14409	1	2026
3280	0.011779200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144107	1	2026
3281	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144126	1	2026
3282	0.008650700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144143	1	2026
3283	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144161	1	2026
3284	0.008342400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144178	1	2026
3285	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144195	1	2026
3286	0.013204800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144213	1	2026
3287	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144233	1	2026
3288	0.014729250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144252	1	2026
3289	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144269	1	2026
3290	0.009621600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144286	1	2026
3291	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144304	1	2026
3292	0.009503550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144321	1	2026
3293	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144339	1	2026
3294	0.009849400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144356	1	2026
3295	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144374	1	2026
3296	0.006702500000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144392	1	2026
3297	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144409	1	2026
3298	0.009111100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144427	1	2026
3299	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144445	1	2026
3300	0.009731750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144463	1	2026
3301	0.000001800000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14448	1	2026
3302	0.010200800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144497	1	2026
3303	0.000002050000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144515	1	2026
3304	0.007301600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144533	1	2026
3305	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144551	1	2026
3306	0.005404650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144568	1	2026
3307	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144586	1	2026
3308	0.005903300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144603	1	2026
3309	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144635	1	2026
3310	0.003948300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144652	1	2026
3311	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14467	1	2026
3312	0.015158350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144686	1	2026
3313	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144704	1	2026
3314	0.004435200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144722	1	2026
3315	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144739	1	2026
3316	0.003038400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144757	1	2026
3317	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144775	1	2026
3318	0.003171350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144799	1	2026
3319	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144833	1	2026
3320	0.004113500000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144861	1	2026
3321	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14489	1	2026
3322	0.001274450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144915	1	2026
3323	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144934	1	2026
3324	0.000787250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144953	1	2026
3325	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144971	1	2026
3326	0.000359750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.144989	1	2026
3327	0.001149500000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145006	1	2026
3328	0.028806750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145024	1	2026
3329	0.028954100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145042	1	2026
3330	0.027848600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14506	1	2026
3331	0.029693700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145077	1	2026
3332	0.030362850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145095	1	2026
3333	0.032379000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145112	1	2026
3334	0.132055450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145131	1	2026
3335	0.065401800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145149	1	2026
3336	0.052595650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145167	1	2026
3337	0.045613550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145185	1	2026
3338	0.048030250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145202	1	2026
3339	0.047365300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14522	1	2026
3340	0.051649700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145246	1	2026
3341	0.069561750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145278	1	2026
3342	0.096947750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145309	1	2026
3343	0.074448450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145342	1	2026
3344	0.055132950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145374	1	2026
3345	0.105457950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145405	1	2026
3346	0.042341050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145436	1	2026
3347	0.068869750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145468	1	2026
3348	0.094079850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145494	1	2026
3349	0.128284250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145527	1	2026
3350	0.101854150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145558	1	2026
3351	0.057997450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145591	1	2026
3352	0.061318600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145614	1	2026
3353	0.064635800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145643	1	2026
3354	0.063415700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145662	1	2026
3355	0.112015750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145679	1	2026
3356	0.146986900000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145697	1	2026
3357	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145719	1	2026
3358	0.101025950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145736	1	2026
3359	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145754	1	2026
3360	0.051835700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145772	1	2026
3361	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145789	1	2026
3362	0.017504400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145807	1	2026
3363	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145833	1	2026
3364	0.015399450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14585	1	2026
3365	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145868	1	2026
3366	0.023131400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145886	1	2026
3367	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145916	1	2026
3368	0.055379000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145934	1	2026
3369	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145952	1	2026
3370	0.087915300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145969	1	2026
3371	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.145988	1	2026
3372	0.026265600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146006	1	2026
3373	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146024	1	2026
3374	0.014849450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146042	1	2026
3375	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146059	1	2026
3376	0.016130400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146078	1	2026
3377	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146095	1	2026
3378	0.021067200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146113	1	2026
3379	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146131	1	2026
3380	0.015807000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14615	1	2026
3381	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146167	1	2026
3382	0.047173200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146184	1	2026
3383	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146206	1	2026
3384	0.055857600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146223	1	2026
3385	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146242	1	2026
3386	0.044627550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146259	1	2026
3387	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146276	1	2026
3388	0.010034600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146294	1	2026
3389	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146311	1	2026
3390	0.014875200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14633	1	2026
3391	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146347	1	2026
3392	0.022405500000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146364	1	2026
3393	0.000001800000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146383	1	2026
3394	0.033322450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.1464	1	2026
3395	0.000002050000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146419	1	2026
3396	0.023663150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146436	1	2026
3397	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146453	1	2026
3398	0.010178100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146471	1	2026
3399	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146491	1	2026
3400	0.023840250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146511	1	2026
3401	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146529	1	2026
3402	0.011610000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146546	1	2026
3403	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146564	1	2026
3404	0.034666500000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146581	1	2026
3405	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146599	1	2026
3406	0.009563350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146616	1	2026
3407	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146633	1	2026
3408	0.004655850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146651	1	2026
3409	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146668	1	2026
3410	0.013856000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146685	1	2026
3411	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146703	1	2026
3412	0.012660400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14672	1	2026
3413	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146737	1	2026
3414	0.007356850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146755	1	2026
3415	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146772	1	2026
3416	0.001434950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146789	1	2026
3417	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146806	1	2026
3418	0.001021200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14683	1	2026
3419	0.000703750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146848	1	2026
3420	0.016915700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146865	1	2026
3421	0.017362650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146884	1	2026
3422	0.017747350000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146901	1	2026
3423	0.018616550000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146919	1	2026
3424	0.019206050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146936	1	2026
2689	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123786	1	2026
2690	0.018507600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123873	1	2026
2691	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123922	1	2026
2692	0.012490400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123964	1	2026
2693	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12401	1	2026
2694	0.006693600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124071	1	2026
2695	0.006541250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124117	1	2026
2696	0.042222100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124163	1	2026
2697	0.025669400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124211	1	2026
2698	0.039260450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124259	1	2026
2699	0.017690350000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124302	1	2026
2700	0.041401000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124346	1	2026
2701	0.042444500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124393	1	2026
2702	0.021455050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12444	1	2026
2703	0.046303600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124487	1	2026
2704	0.028336450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124533	1	2026
2705	0.040010300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124581	1	2026
2706	0.030772650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124628	1	2026
2707	0.034874250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124674	1	2026
2708	0.038770200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124721	1	2026
2709	0.035583600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124769	1	2026
2710	0.038564450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12482	1	2026
2711	0.038786900000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12487	1	2026
2712	0.039524350000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124918	1	2026
2713	0.039233150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.124967	1	2026
2714	0.040958100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125013	1	2026
2715	0.040988200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12506	1	2026
2716	0.039082850000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125113	1	2026
2717	0.043358900000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125157	1	2026
2718	0.036804250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125201	1	2026
2719	0.042755350000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125248	1	2026
2720	0.044025050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125295	1	2026
2721	0.047842950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125339	1	2026
2722	0.040252100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125384	1	2026
2723	0.045084800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125429	1	2026
2724	0.012297600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125476	1	2026
2725	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125527	1	2026
2726	0.014044800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125588	1	2026
2727	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125641	1	2026
2728	0.012454750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125689	1	2026
2729	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125735	1	2026
2730	0.016949500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125784	1	2026
2731	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125836	1	2026
2732	0.016026400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125887	1	2026
2733	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125935	1	2026
2734	0.015465600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.125982	1	2026
2735	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12603	1	2026
2736	0.012972000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126076	1	2026
2737	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126123	1	2026
2738	0.014861400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12617	1	2026
2739	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126233	1	2026
2740	0.009305500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12628	1	2026
2741	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126337	1	2026
2742	0.017675100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12639	1	2026
2743	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126446	1	2026
2744	0.014378000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.1265	1	2026
2745	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12655	1	2026
2746	0.012268800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126599	1	2026
2747	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126651	1	2026
2748	0.010803300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126703	1	2026
2502	167.000000000000000	USD	t	[RESERVATION] D2ls v5	2	RESERVATION	Virtual Machines	2026-04-17 09:28:48.104996	\N	2026
2503	47.830000000000000	USD	t	[RESERVATION] D2s v5	2	RESERVATION	Virtual Machines	2026-04-17 09:28:48.105081	\N	2026
2504	0.299678400000000	USD	t	Snapshots LRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.105158	\N	2026
2505	3.599769600000000	USD	t	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.10519	\N	2026
2506	3.058422600000000	USD	f	E10 ZRS Disk Operations	2	DISK	Storage	2026-04-17 09:28:48.10522	1	2026
2507	3.599769600000000	USD	f	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.105246	1	2026
2508	3.599769600000000	USD	f	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.105273	2	2026
2509	1.535901696000000	USD	f	S4 LRS Disk	2	DISK	Storage	2026-04-17 09:28:48.105344	2	2026
2510	0.019123050000000	USD	f	S4 LRS Disk Operations	2	DISK	Storage	2026-04-17 09:28:48.113426	2	2026
2511	2.989495000000000	USD	f	E10 ZRS Disk Operations	2	DISK	Storage	2026-04-17 09:28:48.113637	3	2026
2512	3.599769600000000	USD	f	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.11368	3	2026
2513	3.917715400000000	USD	f	E10 ZRS Disk Operations	2	DISK	Storage	2026-04-17 09:28:48.113735	4	2026
2514	3.599769600000000	USD	f	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.113775	4	2026
2515	3.599769600000000	USD	f	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.113858	4	2026
2516	0.983328400000000	USD	f	E10 ZRS Disk Operations	2	DISK	Storage	2026-04-17 09:28:48.113939	5	2026
2517	3.599769600000000	USD	f	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.114026	5	2026
2518	1.378336200000000	USD	f	E10 ZRS Disk Operations	2	DISK	Storage	2026-04-17 09:28:48.114065	7	2026
2519	3.599769600000000	USD	f	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.114103	7	2026
2520	1.956766400000000	USD	f	E10 ZRS Disk Operations	2	DISK	Storage	2026-04-17 09:28:48.114141	6	2026
2521	3.599769600000000	USD	f	E4 ZRS Disk	2	DISK	Storage	2026-04-17 09:28:48.114193	6	2026
2522	0.516364800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.114318	1	2026
2523	0.008128750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.114416	1	2026
2524	0.052140550000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.114545	1	2026
2525	0.027647650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.114627	1	2026
2526	0.041678450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.11474	1	2026
2527	0.018768850000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.114821	1	2026
2528	0.045659900000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.114886	1	2026
2529	0.046602750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.114945	1	2026
2530	0.024737950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115007	1	2026
2531	0.053425800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115084	1	2026
2532	0.026320250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115147	1	2026
2533	0.039650750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115207	1	2026
2534	0.057313500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115268	1	2026
2535	0.072613050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115342	1	2026
2536	0.080431100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115406	1	2026
2537	0.102601600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115467	1	2026
2538	0.094441550000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115525	1	2026
2539	0.089811700000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115588	1	2026
2540	0.092795650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115648	1	2026
2541	0.106565300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115707	1	2026
2542	0.107569400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115768	1	2026
2543	0.112108500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115836	1	2026
2544	0.141394350000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115897	1	2026
2545	0.136025850000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.115971	1	2026
2546	0.118411100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116036	1	2026
2547	0.126722950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116096	1	2026
2548	0.130817500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116156	1	2026
2549	0.142918600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116219	1	2026
2550	0.138091450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116279	1	2026
2551	0.156578300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116351	1	2026
2552	0.126000000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.11641	1	2026
2553	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116495	1	2026
2554	0.121094400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116556	1	2026
2555	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116636	1	2026
2556	0.018310100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116701	1	2026
2557	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116761	1	2026
2558	0.024273600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116826	1	2026
2559	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116886	1	2026
2560	0.018480000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.116946	1	2026
2561	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117011	1	2026
2562	0.023875200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117068	1	2026
2563	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117129	1	2026
2564	0.044022000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117186	1	2026
2565	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117244	1	2026
2566	0.023786400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117299	1	2026
2567	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117354	1	2026
2568	0.019832400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117411	1	2026
2569	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117483	1	2026
2570	0.009168000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117539	1	2026
2571	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117599	1	2026
2572	0.013490750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117654	1	2026
2573	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.11771	1	2026
2574	0.011296800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117777	1	2026
2575	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117852	1	2026
2576	0.016646300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117921	1	2026
2577	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.117987	1	2026
2578	0.078873600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118039	1	2026
2579	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118088	1	2026
2580	0.068927600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118136	1	2026
2581	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118188	1	2026
2582	0.053760000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.11824	1	2026
2583	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118298	1	2026
2584	0.049167300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118351	1	2026
2585	0.000001850000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118428	1	2026
2586	0.055666450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118482	1	2026
2587	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118535	1	2026
2588	0.046379050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118592	1	2026
2589	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118648	1	2026
2590	0.040584000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118701	1	2026
2591	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118754	1	2026
2592	0.040964400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118808	1	2026
2593	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118868	1	2026
2594	0.033955200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118917	1	2026
2595	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.118963	1	2026
2596	0.026703600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.11901	1	2026
2597	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119064	1	2026
2598	0.022838400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119116	1	2026
2599	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119167	1	2026
2600	0.019944000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119222	1	2026
2601	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119274	1	2026
2602	0.016200850000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119326	1	2026
2603	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119372	1	2026
2604	0.011685600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119425	1	2026
2605	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119475	1	2026
2606	0.009374400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119526	1	2026
2607	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119574	1	2026
2608	0.005086800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119627	1	2026
2609	0.004403250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119678	1	2026
2610	0.047017900000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119728	1	2026
2611	0.022044600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119779	1	2026
2612	0.037669800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119836	1	2026
2613	0.029347800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119889	1	2026
2614	0.021276500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119941	1	2026
2615	0.034926900000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.119995	1	2026
2616	0.018994100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120057	1	2026
2617	0.039809000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120107	1	2026
2618	0.019936250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120154	1	2026
2619	0.026342250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120206	1	2026
2620	0.065260800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120258	1	2026
2621	0.109703500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120307	1	2026
2622	0.101490250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120356	1	2026
2623	0.107941100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12041	1	2026
2624	0.114617450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120461	1	2026
2625	0.120131300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12051	1	2026
2626	0.123820700000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120563	1	2026
2627	0.135160050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120612	1	2026
2628	0.142920100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12068	1	2026
2629	0.145360600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12075	1	2026
2630	0.154657800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120807	1	2026
2631	0.161625100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120872	1	2026
3425	0.019754400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146954	1	2026
3426	0.019786800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146971	1	2026
3427	0.021389200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.146988	1	2026
3428	0.020062700000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147007	1	2026
3429	0.020700400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147025	1	2026
3430	0.023332750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147042	1	2026
3431	0.023574800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147059	1	2026
3432	0.023793050000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147076	1	2026
3433	0.024160800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147093	1	2026
3434	0.023539450000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14711	1	2026
3435	0.022863100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147127	1	2026
3436	0.023226600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147145	1	2026
3437	0.046479900000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147172	1	2026
3438	0.013390100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147195	1	2026
3439	0.033275500000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147213	1	2026
3440	0.030790650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14723	1	2026
3441	0.025959300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147248	1	2026
3442	0.026030650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147265	1	2026
3443	0.026371300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147283	1	2026
3444	0.033102200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.1473	1	2026
3445	0.035821150000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147318	1	2026
3446	0.033462950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147344	1	2026
3447	0.041677650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147363	1	2026
3448	0.029025250000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14738	1	2026
3449	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147398	1	2026
3450	0.032354650000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147415	1	2026
3451	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147433	1	2026
3452	0.030125000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14745	1	2026
3453	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147468	1	2026
3454	0.011884500000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147486	1	2026
3455	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147504	1	2026
3456	0.012480600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147522	1	2026
3457	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147543	1	2026
3458	0.017571200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147561	1	2026
3459	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147578	1	2026
3460	0.017751300000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147596	1	2026
3461	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147613	1	2026
3462	0.011100000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147631	1	2026
3463	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147648	1	2026
3464	0.009849100000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147665	1	2026
3465	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147682	1	2026
3466	0.008705800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.1477	1	2026
3467	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147717	1	2026
3468	0.011140600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147734	1	2026
3469	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147752	1	2026
3470	0.013683600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14777	1	2026
3471	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147787	1	2026
3472	0.015375900000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147805	1	2026
3473	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147826	1	2026
3474	0.010576600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147843	1	2026
3475	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14787	1	2026
3476	0.010972800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147888	1	2026
3477	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147905	1	2026
3478	0.009628800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147923	1	2026
3479	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14794	1	2026
3480	0.006491850000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147961	1	2026
3481	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.147979	1	2026
3482	0.009054000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148009	1	2026
3483	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148038	1	2026
3484	0.009189600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148068	1	2026
3485	0.000001800000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148113	1	2026
3486	0.011507000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148138	1	2026
3487	0.000002050000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148157	1	2026
3488	0.007117600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148176	1	2026
3489	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148193	1	2026
3490	0.005575600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148211	1	2026
3491	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148228	1	2026
3492	0.005724000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148251	1	2026
3493	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148269	1	2026
3494	0.004149500000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148286	1	2026
3495	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148304	1	2026
3496	0.018374200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148321	1	2026
3497	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14834	1	2026
3498	0.004149950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148371	1	2026
3499	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148389	1	2026
3500	0.004096950000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148406	1	2026
3501	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148424	1	2026
3502	0.003432000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148441	1	2026
3503	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148459	1	2026
3504	0.004291200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148476	1	2026
3505	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148494	1	2026
3506	0.001562400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148511	1	2026
3507	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148529	1	2026
3508	0.000962400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148546	1	2026
3509	0.000001900000000	USD	f	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148564	1	2026
3510	0.000442750000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148582	1	2026
3511	0.424749600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148601	1	2026
3512	0.013764000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148618	1	2026
3513	0.013578000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14864	1	2026
3514	0.033219600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148657	1	2026
3515	0.012908400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148674	1	2026
3516	0.010192800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148691	1	2026
3517	0.011792400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148709	1	2026
3518	0.015028800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148726	1	2026
3519	0.014136000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148744	1	2026
3520	0.008890800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148762	1	2026
3521	0.012462000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148779	1	2026
3522	0.006547200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148797	1	2026
3523	0.011085600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14882	1	2026
3524	0.021204000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148852	1	2026
3525	0.012350400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14887	1	2026
3526	0.012759600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148887	1	2026
3527	0.014433600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148905	1	2026
3528	0.016293600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148923	1	2026
3529	0.010527600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14894	1	2026
3530	0.011048400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148961	1	2026
3531	0.012090000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148978	1	2026
3532	0.016144800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.148996	1	2026
3533	0.012276000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149013	1	2026
3534	0.013652400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14903	1	2026
3535	0.015475200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149047	1	2026
3536	0.012164400000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149066	1	2026
3537	0.006175200000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149092	1	2026
3538	0.013168800000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.14911	1	2026
3539	0.010788000000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149129	1	2026
3540	0.014061600000000	USD	f	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149146	1	2026
3541	0.000000200000000	USD	t	S4 LRS Disk Operations	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149177	\N	2026
3542	0.660296900000000	USD	t	Snapshots LRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149193	\N	2026
3543	0.079048200000000	USD	t	Snapshots ZRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149208	\N	2026
3544	0.271522800000000	USD	t	Snapshots LRS Snapshots	3	SNAPSHOT	Storage	2026-04-17 09:29:13.149229	\N	2026
3545	0.000010368973017	USD	f	Intra Continent Data Transfer Out	3	VM	Bandwidth	2026-04-17 09:29:13.149253	1	2026
3546	0.960300970000000	USD	f	D2ls v5	3	VM	Virtual Machines	2026-04-17 09:29:13.149257	1	2026
3547	0.000000170990825	USD	f	Intra Continent Data Transfer Out	3	VM	Bandwidth	2026-04-17 09:29:13.149264	2	2026
3548	0.000012043938041	USD	f	Intra Continent Data Transfer Out	3	VM	Bandwidth	2026-04-17 09:29:13.149269	3	2026
3549	0.000018507651985	USD	f	Intra Continent Data Transfer Out	3	VM	Bandwidth	2026-04-17 09:29:13.149275	4	2026
3550	0.000008012615144	USD	f	Intra Continent Data Transfer Out	3	VM	Bandwidth	2026-04-17 09:29:13.149281	5	2026
3551	0.184301746000000	USD	f	D2ls v5	3	VM	Virtual Machines	2026-04-17 09:29:13.149284	5	2026
3552	0.000013428851962	USD	f	Intra Continent Data Transfer Out	3	VM	Bandwidth	2026-04-17 09:29:13.149289	6	2026
3553	1.049218930000000	USD	f	D2ls v5	3	VM	Virtual Machines	2026-04-17 09:29:13.149295	6	2026
3554	0.000010058283806	USD	f	Intra Continent Data Transfer Out	3	VM	Bandwidth	2026-04-17 09:29:13.149301	7	2026
3555	24.678452880000000	USD	f	D2ls v5	3	VM	Virtual Machines	2026-04-17 09:29:13.149305	7	2026
3556	0.319623655913978	USD	t	Alerts Metric Monitored	3	ALERT	Azure Monitor	2026-04-17 09:29:13.149322	\N	2026
3557	0.319758064516129	USD	t	Alerts Metric Monitored	3	ALERT	Azure Monitor	2026-04-17 09:29:13.149338	\N	2026
3558	0.277284946236560	USD	t	Alerts Metric Monitored	3	ALERT	Azure Monitor	2026-04-17 09:29:13.149354	\N	2026
3559	0.320295698924731	USD	t	Alerts Metric Monitored	3	ALERT	Azure Monitor	2026-04-17 09:29:13.149369	\N	2026
3560	0.275602064561099	USD	f	Standard Traffic Analytics Processing	3	NSG	Network Watcher	2026-04-17 09:29:13.149385	4	2026
3561	0.097023591771722	USD	t	Standard Traffic Analytics Processing	3	NSG	Network Watcher	2026-04-17 09:29:13.149402	\N	2026
3562	0.305000000000000	USD	t	Standard IPv4 Static Public IP	3	PUBLIC_IP	Virtual Network	2026-04-17 09:29:13.149417	\N	2026
3563	3.720000000000000	USD	f	Standard IPv4 Static Public IP	3	PUBLIC_IP	Virtual Network	2026-04-17 09:29:13.149433	2	2026
3564	3.720000000000000	USD	f	Standard IPv4 Static Public IP	3	PUBLIC_IP	Virtual Network	2026-04-17 09:29:13.149447	3	2026
3565	3.720000000000000	USD	f	Standard IPv4 Static Public IP	3	PUBLIC_IP	Virtual Network	2026-04-17 09:29:13.149462	4	2026
3566	3.720000000000000	USD	f	Standard IPv4 Static Public IP	3	PUBLIC_IP	Virtual Network	2026-04-17 09:29:13.149477	4	2026
3567	3.720000000000000	USD	f	Standard IPv4 Static Public IP	3	PUBLIC_IP	Virtual Network	2026-04-17 09:29:13.149492	6	2026
3568	1.704832273820000	USD	t	Analytics Logs Data Ingestion	3	LOG_ANALYTICS	Log Analytics	2026-04-17 09:29:13.149508	\N	2026
3569	6.351708694110000	USD	f	Analytics Logs Data Ingestion	3	LOG_ANALYTICS	Log Analytics	2026-04-17 09:29:13.149522	4	2026
3570	1.952491731320000	USD	f	Analytics Logs Data Ingestion	3	LOG_ANALYTICS	Log Analytics	2026-04-17 09:29:13.149537	6	2026
3571	0.000009480000000	USD	t	Intra Continent Data Transfer Out	3	STORAGE	Bandwidth	2026-04-17 09:29:13.149552	\N	2026
3572	0.001949620000000	USD	t	All Other Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149567	\N	2026
3573	0.003255580000000	USD	t	Cool Data Retrieval	3	STORAGE	Storage	2026-04-17 09:29:13.149582	\N	2026
3574	0.000409950000000	USD	t	Cool LRS Data Stored	3	STORAGE	Storage	2026-04-17 09:29:13.149597	\N	2026
3575	1.823360000000000	USD	t	Cool LRS Write Operations	3	STORAGE	Storage	2026-04-17 09:29:13.14961	\N	2026
3576	0.003033000000000	USD	t	Cool Read Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149624	\N	2026
3577	0.040548600000000	USD	t	LRS List and Create Container Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149638	\N	2026
3578	0.054899532000000	USD	t	Class 2 Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149654	\N	2026
3579	0.000025524000000	USD	t	Delete Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149668	\N	2026
3580	0.000970092000000	USD	t	LRS Class 1 Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149682	\N	2026
3581	0.001664220000000	USD	t	LRS Data Stored	3	STORAGE	Storage	2026-04-17 09:29:13.149697	\N	2026
3582	0.003608460000000	USD	t	LRS List and Create Container Operations	3	STORAGE	Storage	2026-04-17 09:29:13.14971	\N	2026
3583	0.604212348000000	USD	t	LRS Write Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149724	\N	2026
3584	0.020688450000000	USD	t	Protocol Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149738	\N	2026
3585	0.153605958000000	USD	t	Read Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149752	\N	2026
3586	0.000000720000000	USD	t	Scan Operations	3	STORAGE	Storage	2026-04-17 09:29:13.149766	\N	2026
3587	0.000025560000000	USD	t	Write Operations	3	STORAGE	Storage	2026-04-17 09:29:13.14978	\N	2026
3905	0.041921800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753913	1	2026
3906	0.048036150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75393	1	2026
3907	0.048452600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753948	1	2026
3908	0.043338400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753967	1	2026
3909	0.075341550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753984	1	2026
3910	0.070324200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754001	1	2026
3911	0.065603650000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754019	1	2026
3912	0.042499350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754036	1	2026
3913	0.035491650000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754054	1	2026
3914	0.041347550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754071	1	2026
3915	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75409	1	2026
3916	0.032702800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754107	1	2026
3917	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754125	1	2026
3918	0.035171950000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754142	1	2026
3919	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754161	1	2026
3920	0.017949550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754178	1	2026
3921	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.754195	1	2026
3922	0.010994250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761078	1	2026
3923	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761132	1	2026
3924	0.017630750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761152	1	2026
3925	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761172	1	2026
3926	0.023705150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761195	1	2026
3927	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761231	1	2026
3928	0.013675700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761251	1	2026
3929	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761271	1	2026
3930	0.016416250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76129	1	2026
3931	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761309	1	2026
3932	0.048833850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76134	1	2026
3933	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761359	1	2026
3934	0.050750100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761384	1	2026
3935	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76142	1	2026
3936	0.032195000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761449	1	2026
3588	167.000000000000000	USD	t	[RESERVATION] D2ls v5	1	RESERVATION	Virtual Machines	2026-04-17 09:32:14.747697	\N	2026
3589	47.830000000000000	USD	t	[RESERVATION] D2s v5	1	RESERVATION	Virtual Machines	2026-04-17 09:32:14.747721	\N	2026
3590	0.299683200000000	USD	t	Snapshots LRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.747745	\N	2026
3591	3.599769600000000	USD	t	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747756	\N	2026
3592	3.187239000000000	USD	f	E10 ZRS Disk Operations	1	DISK	Storage	2026-04-17 09:32:14.747772	1	2026
3593	3.599769600000000	USD	f	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747778	1	2026
3594	3.599769600000000	USD	f	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747785	2	2026
3595	1.535901696000000	USD	f	S4 LRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747806	2	2026
3596	0.026041150000000	USD	f	S4 LRS Disk Operations	1	DISK	Storage	2026-04-17 09:32:14.747834	2	2026
3597	2.925753600000000	USD	f	E10 ZRS Disk Operations	1	DISK	Storage	2026-04-17 09:32:14.747841	3	2026
3598	3.599769600000000	USD	f	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747848	3	2026
3599	4.234855200000000	USD	f	E10 ZRS Disk Operations	1	DISK	Storage	2026-04-17 09:32:14.747855	4	2026
3600	3.599769600000000	USD	f	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747861	4	2026
3601	3.599769600000000	USD	f	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747872	4	2026
3602	0.925404200000000	USD	f	E10 ZRS Disk Operations	1	DISK	Storage	2026-04-17 09:32:14.74789	5	2026
3603	3.599769600000000	USD	f	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747899	5	2026
3604	1.390098800000000	USD	f	E10 ZRS Disk Operations	1	DISK	Storage	2026-04-17 09:32:14.747906	7	2026
3605	3.599769600000000	USD	f	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747913	7	2026
3606	1.996297400000000	USD	f	E10 ZRS Disk Operations	1	DISK	Storage	2026-04-17 09:32:14.74792	6	2026
3607	3.599769600000000	USD	f	E4 ZRS Disk	1	DISK	Storage	2026-04-17 09:32:14.747926	6	2026
3608	0.516373200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.747951	1	2026
3609	0.025203600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.747972	1	2026
3610	0.041219250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74799	1	2026
3611	0.041518100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748007	1	2026
3612	0.007041400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748024	1	2026
3613	0.043851200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748042	1	2026
3614	0.034264000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748059	1	2026
3615	0.037744800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748077	1	2026
3616	0.040224350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748095	1	2026
3617	0.037525250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748112	1	2026
3618	0.007877100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748129	1	2026
3619	0.047958350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748147	1	2026
3620	0.071624450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748165	1	2026
3621	0.073727400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748183	1	2026
3622	0.076977000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.7482	1	2026
3623	0.085141000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748218	1	2026
3624	0.092128100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748236	1	2026
3625	0.103607000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748253	1	2026
3626	0.102253800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748271	1	2026
3627	0.105311600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748288	1	2026
3628	0.065860400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748305	1	2026
3629	0.107309750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748323	1	2026
3630	0.121637600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748341	1	2026
3631	0.114788800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748358	1	2026
3632	0.123258000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748376	1	2026
3633	0.128002150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748394	1	2026
3634	0.125341600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748411	1	2026
3635	0.121737000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748429	1	2026
3636	0.126305550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748447	1	2026
3637	0.127748600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748464	1	2026
3638	0.127305250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748483	1	2026
3639	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748501	1	2026
3640	0.121194750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748519	1	2026
3641	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748536	1	2026
3642	0.035861400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748554	1	2026
3643	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748572	1	2026
3644	0.014059200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74859	1	2026
3645	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748607	1	2026
3646	0.015680050000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748625	1	2026
3647	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748642	1	2026
3648	0.009823450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74866	1	2026
3649	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748678	1	2026
3650	0.012634350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748696	1	2026
3651	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748714	1	2026
3652	0.011760000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748731	1	2026
3653	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74875	1	2026
3654	0.012325850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748775	1	2026
3655	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748793	1	2026
3656	0.020258400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748817	1	2026
3657	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748836	1	2026
3658	0.023293400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748853	1	2026
3659	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748872	1	2026
3660	0.010210900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748889	1	2026
3661	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748907	1	2026
3662	0.007687950000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748925	1	2026
3663	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748942	1	2026
3664	0.055744650000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.748962	1	2026
3665	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74898	1	2026
3666	0.063072000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749015	1	2026
3667	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749044	1	2026
3668	0.060814900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749072	1	2026
3669	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.7491	1	2026
3670	0.076115250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749129	1	2026
3671	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749158	1	2026
3672	0.057852000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749185	1	2026
3673	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749214	1	2026
3674	0.046146250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749244	1	2026
3675	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749274	1	2026
3676	0.041751900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749305	1	2026
3677	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749333	1	2026
3678	0.044452800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749361	1	2026
3679	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74939	1	2026
3680	0.038676000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74942	1	2026
3681	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749449	1	2026
3682	0.035042100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749478	1	2026
3683	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74951	1	2026
3684	0.041590800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749541	1	2026
3685	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749573	1	2026
3686	0.033056450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749603	1	2026
3687	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749633	1	2026
3688	0.023662800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749662	1	2026
3689	0.000002000000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749691	1	2026
3690	0.021133200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74972	1	2026
3691	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.74975	1	2026
3692	0.017481200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749779	1	2026
3693	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749808	1	2026
3694	0.015067200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749842	1	2026
3695	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749875	1	2026
3696	0.010297800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749908	1	2026
3697	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749927	1	2026
3698	0.007867950000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749962	1	2026
3699	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.749991	1	2026
3700	0.004064400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750019	1	2026
3701	0.017718750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750053	1	2026
3702	0.034489600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75007	1	2026
3703	0.035196850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750089	1	2026
3704	0.001533000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750107	1	2026
3705	0.034491050000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750125	1	2026
3706	0.026571350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750143	1	2026
3707	0.025545100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750166	1	2026
3708	0.026678400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750183	1	2026
3709	0.027049700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750201	1	2026
3710	0.026683500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750219	1	2026
3711	0.035274500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750239	1	2026
3712	0.057452000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750256	1	2026
3713	0.081907950000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750274	1	2026
3714	0.087758800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750294	1	2026
3715	0.095665100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750311	1	2026
3716	0.106445450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750335	1	2026
3717	0.106443200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750353	1	2026
3718	0.117448000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750371	1	2026
3719	0.123797450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75039	1	2026
3720	0.131049600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750408	1	2026
3721	0.101156000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750425	1	2026
3722	0.138831700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750443	1	2026
3723	0.146792950000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750461	1	2026
3724	0.150205500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750479	1	2026
3725	0.150931200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750496	1	2026
3726	0.157562050000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750514	1	2026
3727	0.164875750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750532	1	2026
3728	0.162067800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750549	1	2026
3729	0.167592050000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750566	1	2026
3730	0.175860200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750584	1	2026
3731	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750602	1	2026
3732	0.171931250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750619	1	2026
3733	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750636	1	2026
3734	0.029698500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750654	1	2026
3735	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750671	1	2026
3736	0.005073500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750689	1	2026
3737	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750707	1	2026
3738	0.012715450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750725	1	2026
3739	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750742	1	2026
3740	0.050281450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75076	1	2026
3741	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750779	1	2026
3742	0.004797100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750796	1	2026
3743	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75082	1	2026
3744	0.011800300000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750837	1	2026
3745	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750855	1	2026
3746	0.007647500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750874	1	2026
3747	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750891	1	2026
3748	0.014436200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750909	1	2026
3749	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750928	1	2026
3750	0.009696800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750946	1	2026
3751	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750963	1	2026
3752	0.012348650000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750981	1	2026
3753	0.000001950000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.750999	1	2026
3754	0.004430750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751018	1	2026
3755	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751036	1	2026
3756	0.077702550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751053	1	2026
3757	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751071	1	2026
3758	0.095660450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751088	1	2026
3759	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751106	1	2026
3760	0.090354000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751123	1	2026
3761	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751141	1	2026
3762	0.084518400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751158	1	2026
3763	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751175	1	2026
3764	0.078782550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751193	1	2026
3765	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75121	1	2026
3766	0.072460500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751227	1	2026
3767	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751244	1	2026
3768	0.065242600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751262	1	2026
3769	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75128	1	2026
3770	0.062935500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751297	1	2026
3771	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751315	1	2026
3772	0.058066800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751333	1	2026
3773	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751351	1	2026
3774	0.050772000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751369	1	2026
3775	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751386	1	2026
3776	0.046699200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751403	1	2026
3777	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751423	1	2026
3778	0.041463350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751455	1	2026
3779	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751473	1	2026
3780	0.036355200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751491	1	2026
3781	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751508	1	2026
3782	0.030016800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751525	1	2026
3783	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751542	1	2026
3784	0.026250000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75156	1	2026
3785	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751578	1	2026
3786	0.022008000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751595	1	2026
3787	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751613	1	2026
3788	0.015627600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751631	1	2026
3789	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751648	1	2026
3790	0.010156450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751666	1	2026
3791	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751683	1	2026
3792	0.005166950000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751701	1	2026
3793	0.021430800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75172	1	2026
3794	0.035144300000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751737	1	2026
3795	0.034912850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751755	1	2026
3796	0.002730000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751772	1	2026
3797	0.035938800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751791	1	2026
3798	0.034758600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751827	1	2026
3799	0.035230800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75186	1	2026
3800	0.036809800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751889	1	2026
3801	0.037059400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751923	1	2026
3802	0.006065150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751953	1	2026
3803	0.035949450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.751972	1	2026
3804	0.039104700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75199	1	2026
3805	0.038565400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752009	1	2026
3806	0.037885000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752039	1	2026
3807	0.035447200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752065	1	2026
3808	0.040724600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752084	1	2026
3809	0.037724050000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752106	1	2026
3810	0.036167850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752133	1	2026
3811	0.042016900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752152	1	2026
3812	0.008495900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752169	1	2026
3813	0.037884850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752187	1	2026
3814	0.039231150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752203	1	2026
3815	0.045225650000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752221	1	2026
3816	0.042842800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752239	1	2026
3817	0.036427100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752257	1	2026
3818	0.035546900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752277	1	2026
3819	0.039330500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752305	1	2026
3820	0.039786350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752336	1	2026
3821	0.038424250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752353	1	2026
3822	0.038360700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752371	1	2026
3823	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752388	1	2026
3824	0.026634300000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752406	1	2026
3825	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752423	1	2026
3826	0.016200500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752441	1	2026
3827	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752458	1	2026
3828	0.011606500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752476	1	2026
3829	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752494	1	2026
3830	0.010686500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752511	1	2026
3831	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752528	1	2026
3832	0.011337300000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752546	1	2026
3833	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752565	1	2026
3834	0.012460000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752586	1	2026
3835	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752603	1	2026
3836	0.004680000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752621	1	2026
3837	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752638	1	2026
3838	0.007519400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752655	1	2026
3839	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752673	1	2026
3840	0.013530000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75269	1	2026
3841	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752707	1	2026
3842	0.011462250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752725	1	2026
3843	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752742	1	2026
3844	0.013177500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752759	1	2026
3845	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752777	1	2026
3846	0.008669900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752795	1	2026
3847	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752834	1	2026
3848	0.009465900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752853	1	2026
3849	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752871	1	2026
3850	0.008574150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752887	1	2026
3851	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752909	1	2026
3852	0.009034200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752925	1	2026
3853	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75294	1	2026
3854	0.004569600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752957	1	2026
3855	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752976	1	2026
3856	0.006623550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.752993	1	2026
3857	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753017	1	2026
2632	0.161690850000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.120922	1	2026
2633	0.163671250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12097	1	2026
2634	0.177375800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121016	1	2026
2635	0.191626200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121063	1	2026
2636	0.190245300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121108	1	2026
2637	0.158742150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121156	1	2026
2638	0.167160000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121204	1	2026
2639	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121256	1	2026
2640	0.169265850000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121305	1	2026
2641	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121357	1	2026
2642	0.019530150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121405	1	2026
2643	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121474	1	2026
2644	0.011905400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121522	1	2026
2645	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12157	1	2026
2646	0.024013300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12162	1	2026
2647	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121669	1	2026
2648	0.016445000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121721	1	2026
2649	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12177	1	2026
2650	0.019836000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121824	1	2026
2651	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121872	1	2026
2652	0.015941750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.121941	1	2026
2653	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122007	1	2026
2654	0.016196600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122059	1	2026
2655	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12211	1	2026
2656	0.011040950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122159	1	2026
2657	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122208	1	2026
2658	0.015374050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122263	1	2026
2659	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122314	1	2026
2660	0.013652500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122365	1	2026
2661	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122421	1	2026
2662	0.018584400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12247	1	2026
2663	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12252	1	2026
2664	0.099562000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122567	1	2026
2665	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122616	1	2026
2666	0.108741200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122665	1	2026
2667	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122712	1	2026
2668	0.082703800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122758	1	2026
2669	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122818	1	2026
2670	0.076445650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122872	1	2026
2671	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122923	1	2026
2672	0.079279200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.122969	1	2026
2673	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123016	1	2026
2674	0.064006800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123061	1	2026
2675	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123111	1	2026
2676	0.061404000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123158	1	2026
2677	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123208	1	2026
2678	0.059119200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123254	1	2026
2679	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.1233	1	2026
2680	0.047817600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123354	1	2026
2681	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123399	1	2026
2682	0.041605200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123445	1	2026
2683	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12349	1	2026
2684	0.035229600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123538	1	2026
2685	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123583	1	2026
2686	0.030246000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123629	1	2026
2687	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123689	1	2026
2688	0.024782400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.123735	1	2026
2749	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126748	1	2026
2750	0.009945600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126815	1	2026
2751	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126862	1	2026
2752	0.007326000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126906	1	2026
2753	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.126953	1	2026
2754	0.005896000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127021	1	2026
2755	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127107	1	2026
2756	0.005504700000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127164	1	2026
2757	0.000001850000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127218	1	2026
2758	0.008980400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127275	1	2026
2759	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127316	1	2026
2760	0.008402850000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127357	1	2026
2761	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127396	1	2026
2762	0.007572000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127435	1	2026
2763	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127474	1	2026
2764	0.011307600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127516	1	2026
2765	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127558	1	2026
2766	0.003907200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127599	1	2026
2767	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127638	1	2026
2768	0.003082800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127679	1	2026
2769	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12772	1	2026
2770	0.002695700000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12776	1	2026
2771	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127832	1	2026
2772	0.003414000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127874	1	2026
2773	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127917	1	2026
2774	0.003073250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127957	1	2026
2775	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.127997	1	2026
2776	0.002029400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128035	1	2026
2777	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128142	1	2026
2778	0.001195200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128197	1	2026
2779	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128237	1	2026
2780	0.000723950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128276	1	2026
2781	0.005900500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128314	1	2026
2782	0.038032600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128352	1	2026
2783	0.021390100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128389	1	2026
2784	0.033437600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128427	1	2026
2785	0.016857150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128466	1	2026
2786	0.036778850000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128504	1	2026
2787	0.038273450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128544	1	2026
2788	0.030607200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128585	1	2026
2789	0.056399200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128623	1	2026
2790	0.034623050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128662	1	2026
2791	0.038264150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12871	1	2026
2792	0.026374200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128751	1	2026
2793	0.038315600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128784	1	2026
2794	0.043862300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128826	1	2026
2795	0.057997600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128864	1	2026
2796	0.066753200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128902	1	2026
2797	0.055793200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128937	1	2026
2798	0.035949350000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.128974	1	2026
2799	0.041473000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129009	1	2026
2800	0.041887250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129047	1	2026
2801	0.042744100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129083	1	2026
2802	0.073757950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129121	1	2026
2803	0.114686650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129158	1	2026
2804	0.071257300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129195	1	2026
2805	0.044826300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12923	1	2026
2806	0.048361650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129268	1	2026
2807	0.062875100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129308	1	2026
2808	0.048296200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129344	1	2026
2809	0.108935700000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129381	1	2026
2810	0.109502400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129416	1	2026
2811	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129471	1	2026
2812	0.069012350000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129506	1	2026
2813	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.12954	1	2026
2814	0.016485600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129578	1	2026
2815	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129616	1	2026
2816	0.027975200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129653	1	2026
2817	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129685	1	2026
2818	0.024205100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129717	1	2026
2819	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129757	1	2026
2820	0.027887500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129794	1	2026
2821	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129839	1	2026
2822	0.383490950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129877	1	2026
2823	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129909	1	2026
2824	0.080225550000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129942	1	2026
2825	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.129976	1	2026
2826	0.038554950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130013	1	2026
2827	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130049	1	2026
2828	0.015447750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130087	1	2026
2829	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130124	1	2026
2830	0.018268250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130159	1	2026
2831	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130196	1	2026
2832	0.014352300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130234	1	2026
2833	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130271	1	2026
2834	0.019192150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130308	1	2026
2835	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130349	1	2026
2836	0.039859200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130383	1	2026
2837	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130419	1	2026
2838	0.065429950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130456	1	2026
2839	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130492	1	2026
2840	0.035859500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130528	1	2026
2841	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130564	1	2026
2842	0.013699550000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130602	1	2026
2843	0.000001850000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130637	1	2026
2844	0.019300750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130673	1	2026
2845	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130708	1	2026
2846	0.026970650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130744	1	2026
2847	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130781	1	2026
2848	0.016395500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130823	1	2026
2849	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130863	1	2026
2850	0.026082000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130905	1	2026
2851	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13094	1	2026
2852	0.035788100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.130974	1	2026
2853	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131011	1	2026
2854	0.021283550000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131048	1	2026
2855	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131088	1	2026
2856	0.004824000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131126	1	2026
2857	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131161	1	2026
2858	0.004596000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131197	1	2026
2859	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131235	1	2026
2860	0.004094150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131272	1	2026
2861	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131308	1	2026
2862	0.002811600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131345	1	2026
2863	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131385	1	2026
2864	0.005704800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131422	1	2026
2865	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131459	1	2026
2866	0.004070100000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131512	1	2026
2867	0.003867000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131549	1	2026
2868	0.025104150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131585	1	2026
2869	0.014998550000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131627	1	2026
2870	0.023573550000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131668	1	2026
2871	0.010158050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131707	1	2026
2872	0.026433150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131747	1	2026
2873	0.027192700000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131786	1	2026
2874	0.013912150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131829	1	2026
2875	0.029680800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131867	1	2026
2876	0.019462450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131906	1	2026
2877	0.025241150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131946	1	2026
2878	0.020422450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.131987	1	2026
2879	0.022821400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13204	1	2026
2880	0.025626650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132078	1	2026
2881	0.025303400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132117	1	2026
2882	0.025409050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132156	1	2026
2883	0.025541300000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132195	1	2026
2884	0.026057500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132231	1	2026
2885	0.028707600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132286	1	2026
2886	0.028115650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132338	1	2026
2887	0.029060050000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13238	1	2026
2888	0.027625800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132419	1	2026
2889	0.032721650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132456	1	2026
2890	0.029298650000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132494	1	2026
2891	0.031093800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132532	1	2026
2892	0.030411250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132571	1	2026
2893	0.036606600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13261	1	2026
2894	0.034815900000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132645	1	2026
2895	0.027364550000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132684	1	2026
2896	0.011088000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132722	1	2026
2897	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132763	1	2026
2898	0.012379950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132801	1	2026
2899	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13285	1	2026
2900	0.011596150000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13289	1	2026
2901	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.132957	1	2026
2902	0.015518900000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133001	1	2026
2903	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133037	1	2026
2904	0.015129400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133075	1	2026
2905	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133111	1	2026
2906	0.014513950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13316	1	2026
2907	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133196	1	2026
2908	0.011708750000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133237	1	2026
2909	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133273	1	2026
2910	0.014968800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133309	1	2026
2911	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133346	1	2026
2912	0.008643600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133382	1	2026
2913	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133422	1	2026
2914	0.009124950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133458	1	2026
2915	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133496	1	2026
2916	0.013286000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133532	1	2026
2917	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133568	1	2026
2918	0.011830950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133605	1	2026
2919	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133643	1	2026
2920	0.010587600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133681	1	2026
2921	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133718	1	2026
2922	0.009666500000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133754	1	2026
2923	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13379	1	2026
2924	0.007520950000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133832	1	2026
2925	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133873	1	2026
2926	0.006064800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13391	1	2026
2927	0.000002000000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133951	1	2026
2928	0.005566900000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.133988	1	2026
2929	0.000001750000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134025	1	2026
2930	0.009581000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134061	1	2026
2931	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134097	1	2026
2932	0.008534350000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134134	1	2026
2933	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134171	1	2026
2934	0.009432000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134207	1	2026
2935	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134246	1	2026
2936	0.006858000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134282	1	2026
2937	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134318	1	2026
2938	0.003763200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134354	1	2026
2939	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134391	1	2026
2940	0.003175200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134429	1	2026
2941	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134465	1	2026
2942	0.002681250000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134506	1	2026
2943	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134544	1	2026
2944	0.003679800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13474	1	2026
2945	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134775	1	2026
2946	0.003312000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134814	1	2026
2947	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13485	1	2026
2948	0.002055450000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134889	1	2026
2949	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134925	1	2026
2950	0.002001600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134961	1	2026
2951	0.000001900000000	USD	f	S4 LRS Disk Operations	2	SNAPSHOT	Storage	2026-04-17 09:28:48.134994	1	2026
2952	0.000468000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135027	1	2026
2953	0.424771200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13506	1	2026
2954	0.013742400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135094	1	2026
2955	0.013574400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135132	1	2026
2956	0.033196800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135168	1	2026
2957	0.012902400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135202	1	2026
2958	0.010214400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135238	1	2026
2959	0.011793600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135273	1	2026
2960	0.015019200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135309	1	2026
2961	0.014112000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135342	1	2026
2962	0.008904000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135379	1	2026
2963	0.012465600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135418	1	2026
2964	0.006552000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135453	1	2026
2965	0.011088000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135489	1	2026
2966	0.021201600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135525	1	2026
2967	0.012331200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135564	1	2026
2968	0.012768000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135601	1	2026
2969	0.014414400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135635	1	2026
2970	0.016296000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135673	1	2026
2971	0.010516800000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135707	1	2026
2972	0.011054400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135743	1	2026
2973	0.012062400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.13578	1	2026
2974	0.016161600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135821	1	2026
2975	0.012264000000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135858	1	2026
2976	0.013675200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135897	1	2026
2977	0.015489600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135936	1	2026
2978	0.012163200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.135973	1	2026
2979	0.006182400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.136007	1	2026
2980	0.013171200000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.136041	1	2026
2981	0.010785600000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.136076	1	2026
2982	0.014078400000000	USD	f	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.136113	1	2026
2983	0.996811200000000	USD	t	Snapshots ZRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.136174	\N	2026
2984	0.271521600000000	USD	t	Snapshots LRS Snapshots	2	SNAPSHOT	Storage	2026-04-17 09:28:48.136227	\N	2026
2985	0.000009201094508	USD	f	Intra Continent Data Transfer Out	2	VM	Bandwidth	2026-04-17 09:28:48.136336	1	2026
2986	1.299802910000000	USD	f	D2ls v5	2	VM	Virtual Machines	2026-04-17 09:28:48.13635	1	2026
2987	0.000009672641754	USD	f	Intra Continent Data Transfer Out	2	VM	Bandwidth	2026-04-17 09:28:48.136363	3	2026
2988	0.194000000000000	USD	f	D2ls v5	2	VM	Virtual Machines	2026-04-17 09:28:48.136369	3	2026
2989	0.000010789558291	USD	f	Intra Continent Data Transfer Out	2	VM	Bandwidth	2026-04-17 09:28:48.136379	4	2026
2990	0.000082307774574	USD	f	Intra Continent Data Transfer Out	2	VM	Bandwidth	2026-04-17 09:28:48.136388	5	2026
2991	0.376684950000000	USD	f	D2ls v5	2	VM	Virtual Machines	2026-04-17 09:28:48.136394	5	2026
2992	0.000009955763817	USD	f	Intra Continent Data Transfer Out	2	VM	Bandwidth	2026-04-17 09:28:48.136402	6	2026
2993	0.381534950000000	USD	f	D2ls v5	2	VM	Virtual Machines	2026-04-17 09:28:48.136408	6	2026
2994	0.000009007751942	USD	f	Intra Continent Data Transfer Out	2	VM	Bandwidth	2026-04-17 09:28:48.136416	7	2026
2995	19.954549000000000	USD	f	D2ls v5	2	VM	Virtual Machines	2026-04-17 09:28:48.136423	7	2026
2996	0.265994623655913	USD	t	Alerts Metric Monitored	2	ALERT	Azure Monitor	2026-04-17 09:28:48.136554	\N	2026
2997	0.265860215053763	USD	t	Alerts Metric Monitored	2	ALERT	Azure Monitor	2026-04-17 09:28:48.136587	\N	2026
2998	0.228494623655914	USD	t	Alerts Metric Monitored	2	ALERT	Azure Monitor	2026-04-17 09:28:48.136617	\N	2026
2999	0.266532258064516	USD	t	Alerts Metric Monitored	2	ALERT	Azure Monitor	2026-04-17 09:28:48.136653	\N	2026
3000	0.217502979561687	USD	f	Standard Traffic Analytics Processing	2	NSG	Network Watcher	2026-04-17 09:28:48.136714	4	2026
3001	0.083629247266799	USD	t	Standard Traffic Analytics Processing	2	NSG	Network Watcher	2026-04-17 09:28:48.13675	\N	2026
3002	3.360000000000000	USD	t	Standard IPv4 Static Public IP	2	PUBLIC_IP	Virtual Network	2026-04-17 09:28:48.136779	\N	2026
3003	3.360000000000000	USD	f	Standard IPv4 Static Public IP	2	PUBLIC_IP	Virtual Network	2026-04-17 09:28:48.136821	2	2026
3004	3.360000000000000	USD	f	Standard IPv4 Static Public IP	2	PUBLIC_IP	Virtual Network	2026-04-17 09:28:48.136857	3	2026
3005	3.360000000000000	USD	f	Standard IPv4 Static Public IP	2	PUBLIC_IP	Virtual Network	2026-04-17 09:28:48.136891	4	2026
3006	3.360000000000000	USD	f	Standard IPv4 Static Public IP	2	PUBLIC_IP	Virtual Network	2026-04-17 09:28:48.136922	4	2026
3007	3.360000000000000	USD	f	Standard IPv4 Static Public IP	2	PUBLIC_IP	Virtual Network	2026-04-17 09:28:48.136952	6	2026
3858	0.005963000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753044	1	2026
3008	1.289905584500000	USD	t	Analytics Logs Data Ingestion	2	LOG_ANALYTICS	Log Analytics	2026-04-17 09:28:48.137003	\N	2026
3009	4.853904851510000	USD	f	Analytics Logs Data Ingestion	2	LOG_ANALYTICS	Log Analytics	2026-04-17 09:28:48.137033	4	2026
3010	1.419342265900000	USD	f	Analytics Logs Data Ingestion	2	LOG_ANALYTICS	Log Analytics	2026-04-17 09:28:48.137065	6	2026
3011	0.000004840000000	USD	t	Intra Continent Data Transfer Out	2	STORAGE	Bandwidth	2026-04-17 09:28:48.137097	\N	2026
3012	0.001745800000000	USD	t	All Other Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137128	\N	2026
3013	0.002631800000000	USD	t	Cool Data Retrieval	2	STORAGE	Storage	2026-04-17 09:28:48.137157	\N	2026
3014	0.000362960000000	USD	t	Cool LRS Data Stored	2	STORAGE	Storage	2026-04-17 09:28:48.137187	\N	2026
3015	1.631420000000000	USD	t	Cool LRS Write Operations	2	STORAGE	Storage	2026-04-17 09:28:48.13722	\N	2026
3016	0.002716000000000	USD	t	Cool Read Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137251	\N	2026
3017	0.032664600000000	USD	t	LRS List and Create Container Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137297	\N	2026
3018	0.051144048000000	USD	t	Class 2 Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137327	\N	2026
3019	0.000023220000000	USD	t	Delete Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137357	\N	2026
3020	0.000876384000000	USD	t	LRS Class 1 Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137391	\N	2026
3021	0.001686840000000	USD	t	LRS Data Stored	2	STORAGE	Storage	2026-04-17 09:28:48.137423	\N	2026
3022	0.003270960000000	USD	t	LRS List and Create Container Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137453	\N	2026
3023	0.545363508000000	USD	t	LRS Write Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137484	\N	2026
3024	0.019092600000000	USD	t	Protocol Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137512	\N	2026
3025	0.140867190000000	USD	t	Read Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137544	\N	2026
3026	0.000000720000000	USD	t	Scan Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137573	\N	2026
3027	0.000023400000000	USD	t	Write Operations	2	STORAGE	Storage	2026-04-17 09:28:48.137602	\N	2026
3859	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753078	1	2026
3860	0.005706850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753103	1	2026
3861	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753121	1	2026
3862	0.004766400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753147	1	2026
3863	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753167	1	2026
3864	0.005068800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753184	1	2026
3865	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753201	1	2026
3866	0.004368000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753218	1	2026
3867	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753235	1	2026
3868	0.003056400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753252	1	2026
3869	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753269	1	2026
3870	0.004041600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753287	1	2026
3871	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753304	1	2026
3872	0.001492600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753322	1	2026
3873	0.000002000000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753339	1	2026
3874	0.002552550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753357	1	2026
3875	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753374	1	2026
3876	0.002261000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753392	1	2026
3877	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75341	1	2026
3878	0.002304000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753427	1	2026
3879	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753444	1	2026
3880	0.000889200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753462	1	2026
3881	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753478	1	2026
3882	0.000949400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753495	1	2026
3883	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753513	1	2026
3884	0.000397200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75353	1	2026
3885	0.019072800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753548	1	2026
3886	0.031149450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753565	1	2026
3887	0.032198000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753582	1	2026
3888	0.006509400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753598	1	2026
3889	0.041409800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753615	1	2026
3890	0.035118600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753632	1	2026
3891	0.031631400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753649	1	2026
3892	0.034764450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753666	1	2026
3893	0.033436900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753683	1	2026
3894	0.007996450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753703	1	2026
3895	0.063240150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75372	1	2026
3896	0.051718450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753738	1	2026
3897	0.050467600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753755	1	2026
3898	0.037482800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753773	1	2026
3899	0.045001600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75379	1	2026
3900	0.046137000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753808	1	2026
3901	0.049865300000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753842	1	2026
3902	0.070017250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.75386	1	2026
3903	0.049946100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753878	1	2026
3904	0.030686000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.753895	1	2026
3937	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761469	1	2026
3938	0.010157500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761487	1	2026
3939	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761509	1	2026
3940	0.008664750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76154	1	2026
3941	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761568	1	2026
3942	0.017710850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761602	1	2026
3943	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761622	1	2026
3944	0.019373200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76164	1	2026
3945	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761661	1	2026
3946	0.031353600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761687	1	2026
3947	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761718	1	2026
3948	0.034966400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761753	1	2026
3949	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761787	1	2026
3950	0.022997750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761831	1	2026
3951	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761867	1	2026
3952	0.005660200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761904	1	2026
3953	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76194	1	2026
3954	0.008380800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.761977	1	2026
3955	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762014	1	2026
3956	0.007458000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762049	1	2026
3957	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762079	1	2026
3958	0.006792000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762115	1	2026
3959	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76215	1	2026
3960	0.018014400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762185	1	2026
3961	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76222	1	2026
3962	0.028611800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762255	1	2026
3963	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762284	1	2026
3964	0.012213600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762319	1	2026
3965	0.000002000000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762356	1	2026
3966	0.003787200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762383	1	2026
3967	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762413	1	2026
3968	0.003659250000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762444	1	2026
3969	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762473	1	2026
3970	0.004881600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762503	1	2026
3971	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762533	1	2026
3972	0.002016000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762564	1	2026
3973	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762593	1	2026
3974	0.005212300000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762632	1	2026
3975	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762674	1	2026
3976	0.003430900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762714	1	2026
3977	0.012342850000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762751	1	2026
3978	0.022098000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762778	1	2026
3979	0.021027500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762796	1	2026
3980	0.001957500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762822	1	2026
3981	0.022430800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762839	1	2026
3982	0.021412600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762856	1	2026
3983	0.021755800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762874	1	2026
3984	0.022846400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762893	1	2026
3985	0.021830900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76291	1	2026
3986	0.005674550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76293	1	2026
3987	0.023686750000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76296	1	2026
3988	0.023521150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.762978	1	2026
3989	0.024407700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763007	1	2026
3990	0.034687000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763026	1	2026
3991	0.026248600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763045	1	2026
3992	0.026373700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763063	1	2026
3993	0.025284200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76308	1	2026
3994	0.022641050000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763098	1	2026
3995	0.028244100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763116	1	2026
3996	0.007946300000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763134	1	2026
3997	0.027368650000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763159	1	2026
3998	0.028545350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763177	1	2026
3999	0.029766600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763194	1	2026
4000	0.028024400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763212	1	2026
4001	0.020385450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763235	1	2026
4002	0.025948350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763265	1	2026
4003	0.027219000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763297	1	2026
4004	0.021966350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763327	1	2026
4005	0.027326150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76336	1	2026
4006	0.027494600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763392	1	2026
4007	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763423	1	2026
4008	0.017611550000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763446	1	2026
4009	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763464	1	2026
4010	0.011214500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763482	1	2026
4011	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763499	1	2026
4012	0.010300800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763516	1	2026
4013	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763536	1	2026
4014	0.005241600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763553	1	2026
4015	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763571	1	2026
4016	0.009899100000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763588	1	2026
4017	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763606	1	2026
4018	0.005756150000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763624	1	2026
4019	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763641	1	2026
4020	0.011870300000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763659	1	2026
4021	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763677	1	2026
4022	0.011615000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763695	1	2026
4023	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763712	1	2026
4024	0.011550000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76373	1	2026
4025	0.000001950000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763748	1	2026
4026	0.012624000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763765	1	2026
4027	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763782	1	2026
4028	0.013582800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763801	1	2026
4029	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763827	1	2026
4030	0.007934800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763845	1	2026
4031	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763863	1	2026
4032	0.009080000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76388	1	2026
4033	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763897	1	2026
4034	0.008062500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763915	1	2026
4035	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763932	1	2026
4036	0.008628400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76395	1	2026
4037	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763967	1	2026
4038	0.007142400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.763986	1	2026
4039	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764003	1	2026
4040	0.006318000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76402	1	2026
4041	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764038	1	2026
4042	0.005594500000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764055	1	2026
4043	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764073	1	2026
4044	0.005240350000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76409	1	2026
4045	0.000002050000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764109	1	2026
4046	0.006236950000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764126	1	2026
4047	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764143	1	2026
4048	0.005064800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76416	1	2026
4049	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764178	1	2026
4050	0.004860000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764195	1	2026
4051	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764212	1	2026
4052	0.003612000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764231	1	2026
4053	0.000001800000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764248	1	2026
4054	0.004765450000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764267	1	2026
4055	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764285	1	2026
4056	0.003007200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764302	1	2026
4057	0.000002000000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76432	1	2026
4058	0.002887200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764337	1	2026
4059	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764354	1	2026
4060	0.002153900000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764372	1	2026
4061	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764389	1	2026
4062	0.002548800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764406	1	2026
4063	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764423	1	2026
4064	0.001659600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764441	1	2026
4065	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764458	1	2026
4066	0.000615700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764476	1	2026
4067	0.000001900000000	USD	f	S4 LRS Disk Operations	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764494	1	2026
4068	0.000342700000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764513	1	2026
4069	0.424749600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76453	1	2026
4070	0.013764000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764548	1	2026
4071	0.013578000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764565	1	2026
4072	0.033219600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764582	1	2026
4073	0.012908400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764611	1	2026
4074	0.010192800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764642	1	2026
4075	0.011792400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764671	1	2026
4076	0.015028800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764701	1	2026
4077	0.014136000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764719	1	2026
4078	0.008890800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764737	1	2026
4079	0.012462000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764754	1	2026
4080	0.006547200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764772	1	2026
4081	0.011085600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76479	1	2026
4082	0.021204000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764807	1	2026
4083	0.012350400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76483	1	2026
4084	0.012759600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764848	1	2026
4085	0.014433600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764865	1	2026
4086	0.016293600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764882	1	2026
4087	0.010527600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.7649	1	2026
4088	0.011048400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764917	1	2026
4089	0.012090000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764934	1	2026
4090	0.016144800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764952	1	2026
4091	0.012276000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.76497	1	2026
4092	0.013652400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.764987	1	2026
4093	0.015475200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.765004	1	2026
4094	0.012164400000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.765021	1	2026
4095	0.006175200000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.765039	1	2026
4096	0.013168800000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.765056	1	2026
4097	0.010788000000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.765074	1	2026
4098	0.014061600000000	USD	f	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.765091	1	2026
4099	0.996811200000000	USD	t	Snapshots ZRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.765104	\N	2026
4100	0.271522800000000	USD	t	Snapshots LRS Snapshots	1	SNAPSHOT	Storage	2026-04-17 09:32:14.765116	\N	2026
4101	0.000009582191706	USD	f	Intra Continent Data Transfer Out	1	VM	Bandwidth	2026-04-17 09:32:14.765134	1	2026
4102	0.185917960000000	USD	f	D2ls v5	1	VM	Virtual Machines	2026-04-17 09:32:14.765138	1	2026
4103	0.000008571892977	USD	f	Intra Continent Data Transfer Out	1	VM	Bandwidth	2026-04-17 09:32:14.765144	3	2026
4104	0.291000000000000	USD	f	D2ls v5	1	VM	Virtual Machines	2026-04-17 09:32:14.765148	3	2026
4105	0.000010477378964	USD	f	Intra Continent Data Transfer Out	1	VM	Bandwidth	2026-04-17 09:32:14.765153	4	2026
4106	0.000003918744624	USD	f	Intra Continent Data Transfer Out	1	VM	Bandwidth	2026-04-17 09:32:14.765159	5	2026
4107	0.097000000000000	USD	f	D2ls v5	1	VM	Virtual Machines	2026-04-17 09:32:14.765163	5	2026
4108	0.000010224692523	USD	f	Intra Continent Data Transfer Out	1	VM	Bandwidth	2026-04-17 09:32:14.765168	6	2026
4109	0.097000000000000	USD	f	D2ls v5	1	VM	Virtual Machines	2026-04-17 09:32:14.765171	6	2026
4110	0.000009467080235	USD	f	Intra Continent Data Transfer Out	1	VM	Bandwidth	2026-04-17 09:32:14.765176	7	2026
4111	23.805458700000000	USD	f	D2ls v5	1	VM	Virtual Machines	2026-04-17 09:32:14.765183	7	2026
4112	0.324596774193548	USD	t	Alerts Metric Monitored	1	ALERT	Azure Monitor	2026-04-17 09:32:14.765201	\N	2026
4113	0.323655913978495	USD	t	Alerts Metric Monitored	1	ALERT	Azure Monitor	2026-04-17 09:32:14.765217	\N	2026
4114	0.276881720430108	USD	t	Alerts Metric Monitored	1	ALERT	Azure Monitor	2026-04-17 09:32:14.765233	\N	2026
4115	0.323924731182796	USD	t	Alerts Metric Monitored	1	ALERT	Azure Monitor	2026-04-17 09:32:14.765249	\N	2026
4116	0.290806278120726	USD	f	Standard Traffic Analytics Processing	1	NSG	Network Watcher	2026-04-17 09:32:14.765265	4	2026
4117	0.088395479042083	USD	t	Standard Traffic Analytics Processing	1	NSG	Network Watcher	2026-04-17 09:32:14.765282	\N	2026
4118	3.720000000000000	USD	t	Standard IPv4 Static Public IP	1	PUBLIC_IP	Virtual Network	2026-04-17 09:32:14.7653	\N	2026
4119	3.720000000000000	USD	f	Standard IPv4 Static Public IP	1	PUBLIC_IP	Virtual Network	2026-04-17 09:32:14.765315	2	2026
4120	3.720000000000000	USD	f	Standard IPv4 Static Public IP	1	PUBLIC_IP	Virtual Network	2026-04-17 09:32:14.765333	3	2026
4121	3.720000000000000	USD	f	Standard IPv4 Static Public IP	1	PUBLIC_IP	Virtual Network	2026-04-17 09:32:14.765354	4	2026
4122	3.720000000000000	USD	f	Standard IPv4 Static Public IP	1	PUBLIC_IP	Virtual Network	2026-04-17 09:32:14.765376	4	2026
4123	3.720000000000000	USD	f	Standard IPv4 Static Public IP	1	PUBLIC_IP	Virtual Network	2026-04-17 09:32:14.765402	6	2026
4124	1.613997852870000	USD	t	Analytics Logs Data Ingestion	1	LOG_ANALYTICS	Log Analytics	2026-04-17 09:32:14.765435	\N	2026
4125	5.784828386870000	USD	f	Analytics Logs Data Ingestion	1	LOG_ANALYTICS	Log Analytics	2026-04-17 09:32:14.765464	4	2026
4126	1.878953243440000	USD	f	Analytics Logs Data Ingestion	1	LOG_ANALYTICS	Log Analytics	2026-04-17 09:32:14.765489	6	2026
4127	0.000004840000000	USD	t	Intra Continent Data Transfer Out	1	STORAGE	Bandwidth	2026-04-17 09:32:14.765516	\N	2026
4128	0.001930270000000	USD	t	All Other Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765542	\N	2026
4129	0.003311890000000	USD	t	Cool Data Retrieval	1	STORAGE	Storage	2026-04-17 09:32:14.765563	\N	2026
4130	0.000416920000000	USD	t	Cool LRS Data Stored	1	STORAGE	Storage	2026-04-17 09:32:14.765579	\N	2026
4131	1.814540000000000	USD	t	Cool LRS Write Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765605	\N	2026
4132	0.003003000000000	USD	t	Cool Read Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765631	\N	2026
4133	0.036115200000000	USD	t	LRS List and Create Container Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765657	\N	2026
4134	0.056846664000000	USD	t	Class 2 Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765678	\N	2026
4135	0.000025740000000	USD	t	Delete Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765695	\N	2026
4136	0.000970380000000	USD	t	LRS Class 1 Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765709	\N	2026
4137	0.001671240000000	USD	t	LRS Data Stored	1	STORAGE	Storage	2026-04-17 09:32:14.765724	\N	2026
4138	0.000529452000000	USD	t	LRS List and Create Container Operations	1	STORAGE	Storage	2026-04-17 09:32:14.76574	\N	2026
4139	0.603769812000000	USD	t	LRS Write Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765755	\N	2026
4140	0.021102450000000	USD	t	Protocol Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765768	\N	2026
4141	0.156130884000000	USD	t	Read Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765783	\N	2026
4142	0.000000720000000	USD	t	Scan Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765796	\N	2026
4143	0.000025812000000	USD	t	Write Operations	1	STORAGE	Storage	2026-04-17 09:32:14.765836	\N	2026
4144	167.000000000000000	USD	t	[RESERVATION] D2ls v5	12	RESERVATION	Virtual Machines	2026-04-17 09:41:21.329344	\N	2025
4145	47.830000000000000	USD	t	[RESERVATION] D2s v5	12	RESERVATION	Virtual Machines	2026-04-17 09:41:21.329374	\N	2025
4146	0.299683200000000	USD	t	Snapshots LRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.3294	\N	2025
4147	0.092572000000000	USD	t	E10 ZRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.329408	\N	2025
4148	3.599769600000000	USD	t	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.329414	\N	2025
4149	3.150436000000000	USD	f	E10 ZRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.32942	1	2025
4150	3.599769600000000	USD	f	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.329426	1	2025
4151	0.013952400000000	USD	f	E10 ZRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.329433	2	2025
4152	3.599769600000000	USD	f	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.329438	2	2025
4153	1.535901696000000	USD	f	S4 LRS Disk	12	DISK	Storage	2026-04-17 09:41:21.329458	2	2025
4154	0.025861750000000	USD	f	S4 LRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.329476	2	2025
4155	2.987766600000000	USD	f	E10 ZRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.329482	3	2025
4156	3.599769600000000	USD	f	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.329488	3	2025
4157	4.280055200000000	USD	f	E10 ZRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.329494	4	2025
4158	3.599769600000000	USD	f	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.329499	4	2025
4159	3.599769600000000	USD	f	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.32951	4	2025
4160	0.834582800000000	USD	f	E10 ZRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.32952	5	2025
4161	3.599769600000000	USD	f	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.329528	5	2025
4162	1.422014000000000	USD	f	E10 ZRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.329535	7	2025
4163	3.599769600000000	USD	f	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.32954	7	2025
4164	2.044723200000000	USD	f	E10 ZRS Disk Operations	12	DISK	Storage	2026-04-17 09:41:21.329546	6	2025
4165	3.599769600000000	USD	f	E4 ZRS Disk	12	DISK	Storage	2026-04-17 09:41:21.329552	6	2025
4166	0.516373200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329573	1	2025
4167	0.002983650000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329591	1	2025
4168	0.025931200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329609	1	2025
4169	0.024374700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329626	1	2025
4170	0.024760700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329644	1	2025
4171	0.025363150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329661	1	2025
4172	0.028309200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329678	1	2025
4173	0.033574000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329696	1	2025
4174	0.031999200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329714	1	2025
4175	0.030755200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329731	1	2025
4176	0.031172400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.32975	1	2025
4177	0.035580050000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329767	1	2025
4178	0.004472250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329785	1	2025
4179	0.053317150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329802	1	2025
4180	0.077959950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329824	1	2025
4181	0.086356200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329842	1	2025
4182	0.081563750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329859	1	2025
4183	0.081997350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329877	1	2025
4184	0.094128600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329895	1	2025
4185	0.123241500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329913	1	2025
4186	0.098335950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.32993	1	2025
4187	0.116901400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329947	1	2025
4188	0.120564400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329964	1	2025
4189	0.079712000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329981	1	2025
4190	0.114787600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.329997	1	2025
4191	0.123340900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330015	1	2025
4192	0.127569200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330033	1	2025
4193	0.138633600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330049	1	2025
4194	0.154880250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330066	1	2025
4195	0.263563450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330083	1	2025
4196	0.108002700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.3301	1	2025
4197	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330118	1	2025
4198	0.137485750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330135	1	2025
4199	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330152	1	2025
4200	0.029369400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33017	1	2025
4201	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330187	1	2025
4202	0.015590400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330205	1	2025
4203	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330222	1	2025
4204	0.013272000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330238	1	2025
4205	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330255	1	2025
4206	0.059816000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330271	1	2025
4207	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330288	1	2025
4208	0.045142350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330305	1	2025
4209	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330321	1	2025
4210	0.009404300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330338	1	2025
4211	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330355	1	2025
4212	0.020505600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330371	1	2025
4213	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330389	1	2025
4214	0.020700000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330406	1	2025
4215	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330422	1	2025
4216	0.012487200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330439	1	2025
4217	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330455	1	2025
4218	0.018295200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330471	1	2025
4219	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330487	1	2025
4220	0.040224000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330504	1	2025
4221	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33052	1	2025
4222	0.077337600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330542	1	2025
4223	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330558	1	2025
4224	0.062211600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330574	1	2025
4225	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330591	1	2025
4226	0.058282800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330609	1	2025
4227	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330626	1	2025
4228	0.058598400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330643	1	2025
4229	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330661	1	2025
4230	0.059562000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330678	1	2025
4231	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330696	1	2025
4232	0.062664000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330713	1	2025
4233	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330731	1	2025
4234	0.050637600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330748	1	2025
4235	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330765	1	2025
4236	0.044496000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330783	1	2025
4237	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.3308	1	2025
4238	0.037963200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330822	1	2025
4239	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330848	1	2025
4240	0.035100450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330865	1	2025
4241	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330883	1	2025
4242	0.035164800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.3309	1	2025
4243	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330917	1	2025
4244	0.026150400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330936	1	2025
4245	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330954	1	2025
4246	0.025158000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.330972	1	2025
4247	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33099	1	2025
4248	0.023198250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331007	1	2025
4249	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331036	1	2025
4250	0.018330350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331055	1	2025
4251	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331072	1	2025
4252	0.013632000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33109	1	2025
4253	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331107	1	2025
4254	0.010227600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331126	1	2025
4255	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331156	1	2025
4256	0.006813600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331188	1	2025
4257	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331206	1	2025
4258	0.003261000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331225	1	2025
4259	0.022061700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331243	1	2025
4260	0.020099850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331264	1	2025
4261	0.020644800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331281	1	2025
4262	0.021047200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.3313	1	2025
4263	0.024068550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331318	1	2025
4264	0.025196700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331335	1	2025
4265	0.026451000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331353	1	2025
4266	0.024374700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331371	1	2025
4267	0.025493350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331389	1	2025
4268	0.020133000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331407	1	2025
4269	0.023683200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331425	1	2025
4270	0.033083600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331443	1	2025
4271	0.090843700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331461	1	2025
4272	0.099742550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331479	1	2025
4273	0.099356200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331496	1	2025
4274	0.103173950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331513	1	2025
4275	0.108322400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331531	1	2025
4276	0.117483600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331549	1	2025
4277	0.125985150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331566	1	2025
4278	0.133283000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331584	1	2025
4279	0.142847100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331602	1	2025
4280	0.145833150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331619	1	2025
4281	0.115301250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331637	1	2025
4282	0.156193700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331655	1	2025
4283	0.163009650000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331672	1	2025
4284	0.166332600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331691	1	2025
4285	0.174088600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331709	1	2025
4286	0.184486100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331731	1	2025
4287	0.157065300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331749	1	2025
4288	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331767	1	2025
4289	0.179203850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331785	1	2025
4290	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331803	1	2025
4291	0.032361950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331829	1	2025
4292	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331848	1	2025
4293	0.009938500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331873	1	2025
4294	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33189	1	2025
4295	0.013990350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331909	1	2025
4296	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331927	1	2025
4297	0.013587000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331946	1	2025
4298	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331963	1	2025
4299	0.011618950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.331981	1	2025
4300	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332	1	2025
4301	0.013148050000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332018	1	2025
4302	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332036	1	2025
4303	0.005237850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332056	1	2025
4304	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332074	1	2025
4305	0.004986550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332098	1	2025
4306	0.000001950000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332118	1	2025
4307	0.007509750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332137	1	2025
4308	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332155	1	2025
4309	0.009474850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332173	1	2025
4310	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332192	1	2025
4311	0.026263250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332209	1	2025
4312	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332227	1	2025
4313	0.098809250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332245	1	2025
4314	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332262	1	2025
4315	0.091628250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332279	1	2025
4316	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332297	1	2025
4317	0.084577250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332314	1	2025
4318	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332332	1	2025
4319	0.080484300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332349	1	2025
4320	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332366	1	2025
4321	0.080278150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332384	1	2025
4322	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332403	1	2025
4323	0.071375650000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332421	1	2025
4324	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332438	1	2025
4325	0.066149700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332455	1	2025
4326	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332473	1	2025
4327	0.061513550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33249	1	2025
4328	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332508	1	2025
4329	0.056811250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332525	1	2025
4330	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332542	1	2025
4331	0.050156300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33256	1	2025
4332	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332577	1	2025
4333	0.045455300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332595	1	2025
4334	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332627	1	2025
4335	0.039972000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332648	1	2025
4336	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332671	1	2025
4337	0.035267450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332689	1	2025
4338	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332706	1	2025
4339	0.029667900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332723	1	2025
4340	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33274	1	2025
4341	0.025139350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332758	1	2025
4342	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33278	1	2025
4343	0.021140800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332802	1	2025
4344	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332823	1	2025
4345	0.014835950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33284	1	2025
4346	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332857	1	2025
4347	0.009948950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332876	1	2025
4348	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332894	1	2025
4349	0.005011700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332915	1	2025
4350	0.003724500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332934	1	2025
4351	0.032356200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332951	1	2025
4352	0.030282700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332969	1	2025
4353	0.030725350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.332986	1	2025
4354	0.032154650000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333003	1	2025
4355	0.034478600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333022	1	2025
4356	0.037494300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333041	1	2025
4357	0.037917750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333059	1	2025
4358	0.037584400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33308	1	2025
4359	0.037764300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333098	1	2025
4360	0.037312000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333116	1	2025
4361	0.002803500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333134	1	2025
4362	0.037886250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333151	1	2025
4363	0.036156450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333181	1	2025
4364	0.033675600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33321	1	2025
4365	0.034808750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333242	1	2025
4366	0.032965200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33327	1	2025
4367	0.036918900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333298	1	2025
4368	0.038649750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333327	1	2025
4369	0.039221100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333358	1	2025
4370	0.044204200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333388	1	2025
4371	0.041445300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333418	1	2025
4372	0.011479300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333448	1	2025
4373	0.041892350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333484	1	2025
4374	0.043146900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333513	1	2025
4375	0.052733000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333542	1	2025
4376	0.052858100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333574	1	2025
4377	0.047347350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333605	1	2025
4378	0.051303150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333629	1	2025
4379	0.022218300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333648	1	2025
4380	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333666	1	2025
4381	0.053216650000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333684	1	2025
4382	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333702	1	2025
4383	0.020128200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333719	1	2025
4384	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333737	1	2025
4385	0.014540700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333756	1	2025
4386	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333773	1	2025
4387	0.019051200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33379	1	2025
4388	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333807	1	2025
4389	0.023550800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333831	1	2025
4390	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333849	1	2025
4391	0.011338600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333866	1	2025
4392	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333885	1	2025
4393	0.010003300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333902	1	2025
4394	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33392	1	2025
4395	0.009573750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333937	1	2025
4396	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333955	1	2025
4397	0.008769450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.333972	1	2025
4398	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33399	1	2025
4399	0.011151200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334008	1	2025
4400	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334026	1	2025
4401	0.014077400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334043	1	2025
4402	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334061	1	2025
4403	0.014208000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334078	1	2025
4404	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334096	1	2025
4405	0.018399600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334113	1	2025
4406	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33413	1	2025
4407	0.006955600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334148	1	2025
4408	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334166	1	2025
4409	0.006630000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334183	1	2025
4410	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334203	1	2025
4411	0.003072000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33422	1	2025
4412	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334237	1	2025
4413	0.010116000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334254	1	2025
4414	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334271	1	2025
4415	0.007173600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334289	1	2025
4416	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334306	1	2025
4417	0.003369600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334324	1	2025
4418	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334341	1	2025
4419	0.005889600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334358	1	2025
4420	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334376	1	2025
4421	0.004897200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334393	1	2025
4422	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334412	1	2025
4423	0.001935900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334429	1	2025
4424	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334446	1	2025
4425	0.001701300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334465	1	2025
4426	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334482	1	2025
4427	0.003129600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334499	1	2025
4428	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334517	1	2025
4429	0.002940000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334536	1	2025
4430	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334554	1	2025
4431	0.002259400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334571	1	2025
4432	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334588	1	2025
4433	0.001868300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334606	1	2025
4434	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334623	1	2025
4435	0.001457450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334641	1	2025
4436	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334658	1	2025
4437	0.001123200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334675	1	2025
4438	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334693	1	2025
4439	0.000759000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33471	1	2025
4440	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334728	1	2025
4441	0.000364550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334745	1	2025
4442	0.003479850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334763	1	2025
4443	0.028005200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33478	1	2025
4444	0.026491800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334798	1	2025
4445	0.026990000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33482	1	2025
4446	0.028533100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334838	1	2025
4447	0.030970900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334856	1	2025
4448	0.045526650000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334874	1	2025
4449	0.049897900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334895	1	2025
4450	0.043043000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334913	1	2025
4451	0.033924100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33493	1	2025
4452	0.035018850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334948	1	2025
4453	0.005753850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334965	1	2025
4454	0.037180300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.334984	1	2025
4455	0.060220100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335001	1	2025
4456	0.085250900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335018	1	2025
4457	0.059621250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335035	1	2025
4458	0.034381350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335052	1	2025
4459	0.040651500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335071	1	2025
4460	0.043761900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335092	1	2025
4461	0.039011250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33511	1	2025
4462	0.075192900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335127	1	2025
4463	0.089508800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335149	1	2025
4464	0.041394200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335173	1	2025
4465	0.038325100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335196	1	2025
4466	0.052096800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335214	1	2025
4467	0.046283500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335231	1	2025
4468	0.048335800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335248	1	2025
4469	0.094871200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335265	1	2025
4470	0.105158850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335283	1	2025
4471	0.053246700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335306	1	2025
4472	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335323	1	2025
4473	0.053070600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33534	1	2025
4474	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335358	1	2025
4475	0.028114200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335376	1	2025
4476	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335393	1	2025
4477	0.018104750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33541	1	2025
4478	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335429	1	2025
4479	0.020297750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335446	1	2025
4480	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335464	1	2025
4481	0.055415550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335481	1	2025
4482	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335499	1	2025
4483	0.077252000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335516	1	2025
4484	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335534	1	2025
4485	0.033993250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335551	1	2025
4486	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33557	1	2025
4487	0.010378750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335588	1	2025
4488	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335605	1	2025
4489	0.015152500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335622	1	2025
4490	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335639	1	2025
4491	0.011414200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335656	1	2025
4492	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335673	1	2025
4493	0.018535550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335691	1	2025
4494	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335708	1	2025
4495	0.077502500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335726	1	2025
4496	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335744	1	2025
4497	0.043479600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335761	1	2025
4498	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335778	1	2025
4499	0.031449600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335796	1	2025
4500	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335819	1	2025
4501	0.010261200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335837	1	2025
4502	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335854	1	2025
4503	0.017450600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335871	1	2025
4504	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335889	1	2025
4505	0.018175300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335906	1	2025
4506	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335923	1	2025
4507	0.019773600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33594	1	2025
4508	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335958	1	2025
4509	0.030270900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335976	1	2025
4510	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.335993	1	2025
4511	0.011966400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336012	1	2025
4512	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336029	1	2025
4513	0.017678400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336047	1	2025
4514	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336064	1	2025
4515	0.005940000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336081	1	2025
4516	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336098	1	2025
4517	0.007169200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336116	1	2025
4518	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336133	1	2025
4519	0.005490800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336151	1	2025
4520	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336168	1	2025
4521	0.004174800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336185	1	2025
4522	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336202	1	2025
4523	0.012453200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33622	1	2025
4524	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336237	1	2025
4525	0.009008300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336255	1	2025
4526	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336273	1	2025
4527	0.006001450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336291	1	2025
4528	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336308	1	2025
4529	0.001739500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336325	1	2025
4530	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336343	1	2025
4531	0.000733150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33636	1	2025
4532	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336378	1	2025
4533	0.000564650000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336395	1	2025
4534	0.001947000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336414	1	2025
4535	0.016703750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336431	1	2025
4536	0.016014350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336448	1	2025
4537	0.015756350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336465	1	2025
4538	0.017999200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336482	1	2025
4539	0.017899600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336499	1	2025
4540	0.021112450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336517	1	2025
4541	0.021907550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336535	1	2025
4542	0.020988100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336552	1	2025
4543	0.019483100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33657	1	2025
4544	0.020937950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336588	1	2025
4545	0.002523150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336605	1	2025
4546	0.025290650000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336622	1	2025
4547	0.027609500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336639	1	2025
4548	0.020201300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336658	1	2025
4549	0.023770950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336675	1	2025
4550	0.021599550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336692	1	2025
4551	0.021075450000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336711	1	2025
4552	0.031928250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336728	1	2025
4553	0.030135300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336745	1	2025
4554	0.030496000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336763	1	2025
4555	0.032121150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336781	1	2025
4556	0.012140550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336798	1	2025
4557	0.031347150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336821	1	2025
4558	0.033728800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336839	1	2025
4559	0.039989300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336856	1	2025
4560	0.035897400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336874	1	2025
4561	0.037065350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336892	1	2025
4562	0.034425950000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336911	1	2025
4563	0.019761300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336928	1	2025
4564	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336945	1	2025
4565	0.038270550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336963	1	2025
4566	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336981	1	2025
4567	0.019530000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.336998	1	2025
4568	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337016	1	2025
4569	0.012510000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337033	1	2025
4570	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337051	1	2025
4571	0.013084500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337069	1	2025
4572	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337087	1	2025
4573	0.016866850000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337104	1	2025
4574	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337121	1	2025
4575	0.013737150000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337138	1	2025
4576	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337156	1	2025
4577	0.009254550000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337174	1	2025
4578	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337191	1	2025
4579	0.008768750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337208	1	2025
4580	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337225	1	2025
4581	0.008209900000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337242	1	2025
4582	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33726	1	2025
4583	0.006364600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337277	1	2025
4584	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337295	1	2025
4585	0.013142350000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337312	1	2025
4586	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337329	1	2025
4587	0.013320000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337348	1	2025
4588	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337365	1	2025
4589	0.011240800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337383	1	2025
4590	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337401	1	2025
4591	0.006566400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337418	1	2025
4592	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337436	1	2025
4593	0.019631700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337454	1	2025
4594	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337471	1	2025
4595	0.007643300000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337489	1	2025
4596	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337506	1	2025
4597	0.008126600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337523	1	2025
4598	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337541	1	2025
4599	0.006733500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337559	1	2025
4600	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337576	1	2025
4601	0.002898500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337594	1	2025
4602	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337611	1	2025
4603	0.005640700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33763	1	2025
4604	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337647	1	2025
4605	0.004545700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337665	1	2025
4606	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337682	1	2025
4607	0.003599250000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337699	1	2025
4608	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337718	1	2025
4609	0.003220700000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337736	1	2025
4610	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337753	1	2025
4611	0.002787600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337771	1	2025
4612	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337788	1	2025
4613	0.002520000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337806	1	2025
4614	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337829	1	2025
4615	0.001072800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337846	1	2025
4616	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337864	1	2025
4617	0.002052750000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337881	1	2025
4618	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.3379	1	2025
4619	0.001464000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337918	1	2025
4620	0.000001800000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337936	1	2025
4621	0.000479500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337957	1	2025
4622	0.000002050000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.337988	1	2025
4623	0.000752100000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338014	1	2025
4624	0.000001900000000	USD	f	S4 LRS Disk Operations	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338034	1	2025
4625	0.000357500000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338052	1	2025
4626	0.424749600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33807	1	2025
4627	0.013764000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338087	1	2025
4628	0.013578000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338105	1	2025
4629	0.033219600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338122	1	2025
4630	0.012908400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33814	1	2025
4631	0.010192800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338158	1	2025
4632	0.011792400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338175	1	2025
4633	0.015028800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338193	1	2025
4634	0.014136000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.33821	1	2025
4635	0.008890800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338228	1	2025
4636	0.012462000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338247	1	2025
4637	0.006547200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338265	1	2025
4638	0.011085600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338282	1	2025
4639	0.021204000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338299	1	2025
4640	0.012350400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338317	1	2025
4641	0.012759600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338334	1	2025
4642	0.014433600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338352	1	2025
4643	0.016293600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338369	1	2025
4644	0.010527600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338387	1	2025
4645	0.011048400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338404	1	2025
4646	0.012090000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338422	1	2025
4647	0.016144800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338439	1	2025
4648	0.012276000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338457	1	2025
4649	0.013652400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338474	1	2025
4650	0.015475200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338492	1	2025
4651	0.012164400000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338509	1	2025
4652	0.006175200000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338526	1	2025
4653	0.013168800000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338543	1	2025
4654	0.010788000000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338561	1	2025
4655	0.014061600000000	USD	f	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338578	1	2025
4656	0.996811200000000	USD	t	Snapshots ZRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338594	\N	2025
4657	0.271522800000000	USD	t	Snapshots LRS Snapshots	12	SNAPSHOT	Storage	2026-04-17 09:41:21.338605	\N	2025
4658	0.000000411272049	USD	t	Intra Continent Data Transfer Out	12	VM	Bandwidth	2026-04-17 09:41:21.33863	\N	2025
4659	0.000009487196803	USD	f	Intra Continent Data Transfer Out	12	VM	Bandwidth	2026-04-17 09:41:21.338637	1	2025
4660	0.194000000000000	USD	f	D2ls v5	12	VM	Virtual Machines	2026-04-17 09:41:21.338641	1	2025
4661	0.000000031292439	USD	f	Intra Continent Data Transfer Out	12	VM	Bandwidth	2026-04-17 09:41:21.338647	2	2025
4662	0.000009740553796	USD	f	Intra Continent Data Transfer Out	12	VM	Bandwidth	2026-04-17 09:41:21.338652	3	2025
4663	0.000012706909329	USD	f	Intra Continent Data Transfer Out	12	VM	Bandwidth	2026-04-17 09:41:21.338658	4	2025
4664	0.000004764143378	USD	f	Intra Continent Data Transfer Out	12	VM	Bandwidth	2026-04-17 09:41:21.338664	5	2025
4665	0.000010268036276	USD	f	Intra Continent Data Transfer Out	12	VM	Bandwidth	2026-04-17 09:41:21.338672	6	2025
4666	1.742769900000000	USD	f	D2ls v5	12	VM	Virtual Machines	2026-04-17 09:41:21.338678	6	2025
4667	0.000009457021952	USD	f	Intra Continent Data Transfer Out	12	VM	Bandwidth	2026-04-17 09:41:21.338683	7	2025
4668	26.626541710000000	USD	f	D2ls v5	12	VM	Virtual Machines	2026-04-17 09:41:21.338687	7	2025
4669	0.330779569892473	USD	t	Alerts Metric Monitored	12	ALERT	Azure Monitor	2026-04-17 09:41:21.338708	\N	2025
4670	0.330779569892473	USD	t	Alerts Metric Monitored	12	ALERT	Azure Monitor	2026-04-17 09:41:21.338726	\N	2025
4671	0.285215053763441	USD	t	Alerts Metric Monitored	12	ALERT	Azure Monitor	2026-04-17 09:41:21.338742	\N	2025
4672	0.322983870967742	USD	t	Alerts Metric Monitored	12	ALERT	Azure Monitor	2026-04-17 09:41:21.338757	\N	2025
4673	0.325936277583241	USD	f	Standard Traffic Analytics Processing	12	NSG	Network Watcher	2026-04-17 09:41:21.338774	4	2025
4674	0.082752460241318	USD	t	Standard Traffic Analytics Processing	12	NSG	Network Watcher	2026-04-17 09:41:21.338791	\N	2025
4675	3.720000000000000	USD	t	Standard IPv4 Static Public IP	12	PUBLIC_IP	Virtual Network	2026-04-17 09:41:21.338807	\N	2025
4676	3.720000000000000	USD	f	Standard IPv4 Static Public IP	12	PUBLIC_IP	Virtual Network	2026-04-17 09:41:21.33883	2	2025
4677	3.720000000000000	USD	f	Standard IPv4 Static Public IP	12	PUBLIC_IP	Virtual Network	2026-04-17 09:41:21.338851	3	2025
4678	3.720000000000000	USD	f	Standard IPv4 Static Public IP	12	PUBLIC_IP	Virtual Network	2026-04-17 09:41:21.338873	4	2025
4679	3.720000000000000	USD	f	Standard IPv4 Static Public IP	12	PUBLIC_IP	Virtual Network	2026-04-17 09:41:21.338889	4	2025
4680	3.720000000000000	USD	f	Standard IPv4 Static Public IP	12	PUBLIC_IP	Virtual Network	2026-04-17 09:41:21.338906	6	2025
4681	1.620741421130000	USD	t	Analytics Logs Data Ingestion	12	LOG_ANALYTICS	Log Analytics	2026-04-17 09:41:21.338922	\N	2025
4682	5.753992980320000	USD	f	Analytics Logs Data Ingestion	12	LOG_ANALYTICS	Log Analytics	2026-04-17 09:41:21.338936	4	2025
4683	1.878644080430000	USD	f	Analytics Logs Data Ingestion	12	LOG_ANALYTICS	Log Analytics	2026-04-17 09:41:21.338951	6	2025
4684	0.000022200000000	USD	t	Intra Continent Data Transfer Out	12	STORAGE	Bandwidth	2026-04-17 09:41:21.338967	\N	2025
4685	0.001939300000000	USD	t	All Other Operations	12	STORAGE	Storage	2026-04-17 09:41:21.338983	\N	2025
4686	0.003568450000000	USD	t	Cool Data Retrieval	12	STORAGE	Storage	2026-04-17 09:41:21.338998	\N	2025
4687	0.000447410000000	USD	t	Cool LRS Data Stored	12	STORAGE	Storage	2026-04-17 09:41:21.339012	\N	2025
4688	1.817300000000000	USD	t	Cool LRS Write Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339031	\N	2025
4689	0.003017000000000	USD	t	Cool Read Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339045	\N	2025
4690	0.055344600000000	USD	t	LRS List and Create Container Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339059	\N	2025
4691	0.056802024000000	USD	t	Class 2 Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339073	\N	2025
4692	0.000025920000000	USD	t	Delete Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339088	\N	2025
4693	0.000970416000000	USD	t	LRS Class 1 Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339103	\N	2025
4694	0.001682700000000	USD	t	LRS Data Stored	12	STORAGE	Storage	2026-04-17 09:41:21.339118	\N	2025
4695	0.000324360000000	USD	t	LRS List and Create Container Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339132	\N	2025
4696	0.600120852000000	USD	t	LRS Write Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339146	\N	2025
4697	0.021013050000000	USD	t	Protocol Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339161	\N	2025
4698	0.157500288000000	USD	t	Read Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339174	\N	2025
4699	0.000000720000000	USD	t	Scan Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339189	\N	2025
4700	0.000026136000000	USD	t	Write Operations	12	STORAGE	Storage	2026-04-17 09:41:21.339203	\N	2025
4701	167.000000000000000	USD	t	[RESERVATION] D2ls v5	11	RESERVATION	Virtual Machines	2026-04-17 09:47:09.273576	\N	2025
4702	47.830000000000000	USD	t	[RESERVATION] D2s v5	11	RESERVATION	Virtual Machines	2026-04-17 09:47:09.273602	\N	2025
4703	0.000004300000000	USD	t	All Other Operations	11	STORAGE	Storage	2026-04-17 09:47:09.273623	\N	2025
4704	0.097493760000000	USD	t	LRS Data Stored	11	STORAGE	Storage	2026-04-17 09:47:09.273641	\N	2025
4705	0.299664000000000	USD	t	Snapshots LRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273662	\N	2025
4706	3.600288000000000	USD	t	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273669	\N	2025
4707	2.938724200000000	USD	f	E10 ZRS Disk Operations	11	DISK	Storage	2026-04-17 09:47:09.273675	1	2025
4708	3.600288000000000	USD	f	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273681	1	2025
4709	0.098187400000000	USD	f	E10 ZRS Disk Operations	11	DISK	Storage	2026-04-17 09:47:09.273687	2	2025
4710	3.600288000000000	USD	f	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273693	2	2025
4711	1.536122880000000	USD	f	S4 LRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273711	2	2025
4712	0.024870000000000	USD	f	S4 LRS Disk Operations	11	DISK	Storage	2026-04-17 09:47:09.27373	2	2025
4713	2.864294000000000	USD	f	E10 ZRS Disk Operations	11	DISK	Storage	2026-04-17 09:47:09.273736	3	2025
4714	3.600288000000000	USD	f	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273742	3	2025
4715	4.108821200000000	USD	f	E10 ZRS Disk Operations	11	DISK	Storage	2026-04-17 09:47:09.273748	4	2025
4716	3.600288000000000	USD	f	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273754	4	2025
4717	3.600288000000000	USD	f	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273763	4	2025
4718	0.741323400000000	USD	f	E10 ZRS Disk Operations	11	DISK	Storage	2026-04-17 09:47:09.273772	5	2025
4719	3.600288000000000	USD	f	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.27378	5	2025
4720	1.719271200000000	USD	f	E10 ZRS Disk Operations	11	DISK	Storage	2026-04-17 09:47:09.273786	7	2025
4721	3.600288000000000	USD	f	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273792	7	2025
4722	2.350206000000000	USD	f	E10 ZRS Disk Operations	11	DISK	Storage	2026-04-17 09:47:09.273798	6	2025
4723	3.600288000000000	USD	f	E4 ZRS Disk	11	DISK	Storage	2026-04-17 09:47:09.273804	6	2025
4724	0.516348000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273832	1	2025
4725	0.002955600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273851	1	2025
4726	0.022849550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273869	1	2025
4727	0.026622150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273886	1	2025
4728	0.025178400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273904	1	2025
4729	0.023396600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273921	1	2025
4730	0.025036000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273938	1	2025
4731	0.030373900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273954	1	2025
4732	0.028095350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273971	1	2025
4733	0.028328850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.273988	1	2025
4734	0.032682750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274005	1	2025
4735	0.027283850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274021	1	2025
4736	0.026036100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274038	1	2025
4737	0.030397200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274056	1	2025
4738	0.030248100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274073	1	2025
4739	0.039595500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274091	1	2025
4740	0.041974350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274107	1	2025
4741	0.042074900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274124	1	2025
4742	0.033524550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27414	1	2025
4743	0.029329200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274157	1	2025
4744	0.030905300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274174	1	2025
4745	0.035550300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274191	1	2025
4746	0.037932150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274208	1	2025
4747	0.045092700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274225	1	2025
4748	0.044697450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274242	1	2025
4749	0.056894450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274258	1	2025
4750	0.044868200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274275	1	2025
4751	0.043483600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274292	1	2025
4752	0.048025700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274309	1	2025
4753	0.039184950000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274326	1	2025
4754	0.053423700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274343	1	2025
4755	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27436	1	2025
4756	0.045046800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274377	1	2025
4757	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274394	1	2025
4758	0.016564800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274411	1	2025
4759	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274428	1	2025
4760	0.011860800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274444	1	2025
4761	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274461	1	2025
4762	0.010918800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274478	1	2025
4763	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274495	1	2025
4764	0.013790400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274512	1	2025
4765	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274529	1	2025
4766	0.014700000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274546	1	2025
4767	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274563	1	2025
4768	0.026166900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274579	1	2025
4769	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274596	1	2025
4770	0.018906000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274613	1	2025
4771	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274629	1	2025
4772	0.008025600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274647	1	2025
4773	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274663	1	2025
4774	0.007660800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274679	1	2025
4775	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274696	1	2025
4776	0.013418750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274713	1	2025
4777	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274731	1	2025
4778	0.007888800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274747	1	2025
4779	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274762	1	2025
4780	0.039484800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274778	1	2025
4781	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274796	1	2025
4782	0.066850800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274818	1	2025
4783	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274835	1	2025
4784	0.065433600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274865	1	2025
4785	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274883	1	2025
4786	0.054486000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.2749	1	2025
4787	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274918	1	2025
4788	0.048417600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274935	1	2025
4789	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274961	1	2025
4790	0.051278000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274978	1	2025
4791	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.274996	1	2025
4792	0.064195200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275013	1	2025
4793	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275031	1	2025
4794	0.037672800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275049	1	2025
4795	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275066	1	2025
4796	0.041148000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275084	1	2025
4797	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275102	1	2025
4798	0.036180000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27512	1	2025
4799	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275137	1	2025
4800	0.029836800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275156	1	2025
4801	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275173	1	2025
4802	0.025141200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275191	1	2025
4803	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275209	1	2025
4804	0.022536000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275226	1	2025
4805	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275244	1	2025
4806	0.018588000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275262	1	2025
4807	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27528	1	2025
4808	0.015835200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275297	1	2025
4809	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275315	1	2025
4810	0.012970800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275332	1	2025
4811	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27535	1	2025
4812	0.015921600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275368	1	2025
4813	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275386	1	2025
4814	0.003816000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275404	1	2025
4815	0.041231050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275422	1	2025
4816	0.001264200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275439	1	2025
4817	0.040946100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275457	1	2025
4818	0.020234450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275475	1	2025
4819	0.024091850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275492	1	2025
4820	0.004234000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27551	1	2025
4821	0.023321600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275528	1	2025
4822	0.043632100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275545	1	2025
4823	0.024472000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275563	1	2025
4824	0.022975200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275582	1	2025
4825	0.025124400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275599	1	2025
4826	0.005731200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275616	1	2025
4827	0.027270000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275634	1	2025
4828	0.033813400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275652	1	2025
4829	0.030361850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27567	1	2025
4830	0.032067400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275687	1	2025
4831	0.027146950000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275704	1	2025
4832	0.024895350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275722	1	2025
4833	0.028933700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27574	1	2025
4834	0.032744100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275771	1	2025
4835	0.032646150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275788	1	2025
4836	0.034628750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275806	1	2025
4837	0.030903900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27583	1	2025
4838	0.069080600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275848	1	2025
4839	0.028811300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275866	1	2025
4840	0.056868100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275883	1	2025
4841	0.019407600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275902	1	2025
4842	0.036856800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275921	1	2025
4843	0.040248000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275938	1	2025
4844	0.000002050000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275956	1	2025
4845	0.042695200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275974	1	2025
4846	0.000001800000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.275992	1	2025
4847	0.019756000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27602	1	2025
4848	0.000002050000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276051	1	2025
4849	0.012447050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27607	1	2025
4850	0.000001800000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276088	1	2025
4851	0.013398700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276106	1	2025
4852	0.000001950000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276124	1	2025
4853	0.019774250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276141	1	2025
4854	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276159	1	2025
4855	0.012928150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276176	1	2025
4856	0.000002050000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276194	1	2025
4857	0.015091200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276212	1	2025
4858	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276231	1	2025
4859	0.015744700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276249	1	2025
4860	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276266	1	2025
4861	0.008959000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276284	1	2025
4862	0.000001800000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276302	1	2025
4863	0.008249200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276319	1	2025
4864	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276338	1	2025
4865	0.004502600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276357	1	2025
4866	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276376	1	2025
4867	0.010851750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276394	1	2025
4868	0.000002050000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276412	1	2025
4869	0.050566900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276429	1	2025
4870	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276448	1	2025
4871	0.097940400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276466	1	2025
4872	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276484	1	2025
4873	0.093650400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276502	1	2025
4874	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27652	1	2025
4875	0.080120250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276539	1	2025
4876	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276556	1	2025
4877	0.073024800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276575	1	2025
4878	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276593	1	2025
4879	0.068581050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276611	1	2025
4880	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27663	1	2025
4881	0.064544650000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276648	1	2025
4882	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276666	1	2025
4883	0.058360400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276684	1	2025
4884	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276702	1	2025
4885	0.052594200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27672	1	2025
4886	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276738	1	2025
4887	0.048417750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276756	1	2025
4888	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276773	1	2025
4889	0.043005550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276791	1	2025
4890	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276815	1	2025
4891	0.036036100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276833	1	2025
4892	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276851	1	2025
4893	0.032750450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276868	1	2025
4894	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276886	1	2025
4895	0.026850450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276905	1	2025
4896	0.000001800000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276923	1	2025
4897	0.020996950000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276941	1	2025
4898	0.000002050000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276959	1	2025
4899	0.015831150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276977	1	2025
4900	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.276994	1	2025
4901	0.010406900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277012	1	2025
4902	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277032	1	2025
4903	0.005559350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27705	1	2025
4904	0.003779250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277067	1	2025
4905	0.029197900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277085	1	2025
4906	0.032220950000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277102	1	2025
4907	0.031354500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27712	1	2025
4908	0.030487350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277137	1	2025
4909	0.032139500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277154	1	2025
4910	0.035137950000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277172	1	2025
4911	0.035077350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277189	1	2025
4912	0.036727500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277207	1	2025
4913	0.032016000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277224	1	2025
4914	0.035155200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277242	1	2025
4915	0.035334300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27726	1	2025
4916	0.037254350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277278	1	2025
4917	0.045190050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277295	1	2025
4918	0.045135300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277313	1	2025
4919	0.040840300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277331	1	2025
4920	0.045418500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277349	1	2025
4921	0.041274500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277367	1	2025
4922	0.039674700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277385	1	2025
4923	0.040716100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277402	1	2025
4924	0.052498050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27742	1	2025
4925	0.041792250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277437	1	2025
4926	0.047271000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277455	1	2025
4927	0.039436200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277473	1	2025
4928	0.067150500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27749	1	2025
4929	0.038755000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277507	1	2025
4930	0.045661500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277524	1	2025
4931	0.060187150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277542	1	2025
4932	0.048119850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27756	1	2025
4933	0.049413350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277577	1	2025
4934	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277594	1	2025
4935	0.043871450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277612	1	2025
4936	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27763	1	2025
4937	0.019105200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277648	1	2025
4938	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277665	1	2025
4939	0.011592000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277683	1	2025
4940	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.2777	1	2025
4941	0.011469600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277719	1	2025
4942	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277736	1	2025
4943	0.019105400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277753	1	2025
4944	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277771	1	2025
4945	0.012900000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277789	1	2025
4946	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277806	1	2025
4947	0.012182400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277829	1	2025
4948	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277846	1	2025
4949	0.017742200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277864	1	2025
4950	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277882	1	2025
4951	0.009696800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.2779	1	2025
4952	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277917	1	2025
4953	0.008450400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277934	1	2025
4954	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277951	1	2025
4955	0.012245700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27797	1	2025
4956	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.277989	1	2025
4957	0.004947600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278006	1	2025
4958	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278023	1	2025
4959	0.012545000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278041	1	2025
4960	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278059	1	2025
4961	0.009792000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278076	1	2025
4962	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278094	1	2025
4963	0.004315650000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278111	1	2025
4964	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278129	1	2025
4965	0.008370000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278146	1	2025
4966	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278163	1	2025
4967	0.006384000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278181	1	2025
4968	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278198	1	2025
4969	0.008725750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278216	1	2025
4970	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278234	1	2025
4971	0.008739150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278251	1	2025
4972	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278269	1	2025
4973	0.005937800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278286	1	2025
4974	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278304	1	2025
4975	0.006876000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278322	1	2025
4976	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27834	1	2025
4977	0.005097600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278357	1	2025
4978	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278375	1	2025
4979	0.004300800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278393	1	2025
4980	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278411	1	2025
4981	0.002980950000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278428	1	2025
4982	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278447	1	2025
4983	0.002974400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278465	1	2025
4984	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278487	1	2025
4985	0.004302000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278505	1	2025
4986	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278522	1	2025
4987	0.003278400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27854	1	2025
4988	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278557	1	2025
4989	0.001573200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278574	1	2025
4990	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278592	1	2025
4991	0.001091150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278609	1	2025
4992	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278627	1	2025
4993	0.000752100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278657	1	2025
4994	0.003282750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278687	1	2025
4995	0.026700450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278716	1	2025
4996	0.032256750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278744	1	2025
4997	0.026001300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278761	1	2025
4998	0.024358200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27878	1	2025
4999	0.028547600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278797	1	2025
5000	0.031803000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278819	1	2025
5001	0.031886300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278836	1	2025
5002	0.039712650000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278862	1	2025
5003	0.037533850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27888	1	2025
5004	0.039585750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278897	1	2025
5005	0.029632800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278914	1	2025
5006	0.034667850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278932	1	2025
5007	0.046647600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278951	1	2025
5008	0.042791350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278969	1	2025
5009	0.070996850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.278987	1	2025
5010	0.075978200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279004	1	2025
5011	0.035158250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279022	1	2025
5012	0.036764400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279039	1	2025
5013	0.041082650000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279057	1	2025
5014	0.051980550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279075	1	2025
5015	0.039760500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279096	1	2025
5016	0.074204250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279113	1	2025
5017	0.066825450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27913	1	2025
5018	0.087661900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279147	1	2025
5019	0.042591750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279166	1	2025
5020	0.052343600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279183	1	2025
5021	0.046748400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279201	1	2025
5022	0.046772250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279218	1	2025
5023	0.092050650000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279235	1	2025
5024	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279253	1	2025
5025	0.092134550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279271	1	2025
5026	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279288	1	2025
5027	0.051573600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279305	1	2025
5028	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279323	1	2025
5029	0.016262400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279341	1	2025
5030	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279358	1	2025
5031	0.015519600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279376	1	2025
5032	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279393	1	2025
5033	0.023150400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27941	1	2025
5034	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279428	1	2025
5035	0.016980000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279445	1	2025
5036	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279463	1	2025
5037	0.063763200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279481	1	2025
5038	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279498	1	2025
5039	0.067967250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279517	1	2025
5040	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279534	1	2025
5041	0.039333800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279551	1	2025
5042	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279568	1	2025
5043	0.009702000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279585	1	2025
5044	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279603	1	2025
5045	0.012587500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27962	1	2025
5046	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279638	1	2025
5047	0.010146000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279655	1	2025
5048	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279673	1	2025
5049	0.014601600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27969	1	2025
5050	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279707	1	2025
5051	0.043411200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279724	1	2025
5052	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279742	1	2025
5053	0.063878400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279759	1	2025
5054	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279776	1	2025
5055	0.034472500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279794	1	2025
5056	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279815	1	2025
5057	0.007711200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279832	1	2025
5058	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279862	1	2025
5059	0.011637600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279879	1	2025
5060	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279896	1	2025
5061	0.012395700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279914	1	2025
5062	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279931	1	2025
5063	0.005821200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.27995	1	2025
5064	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279972	1	2025
5065	0.022704000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.279989	1	2025
5066	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280007	1	2025
5067	0.025580950000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280024	1	2025
5068	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280042	1	2025
5069	0.015129600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28006	1	2025
5070	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280077	1	2025
5071	0.002904550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280095	1	2025
5072	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280113	1	2025
5073	0.005891600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280131	1	2025
5074	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280148	1	2025
5075	0.003504000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280165	1	2025
5076	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280182	1	2025
5077	0.003019200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.2802	1	2025
5078	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280217	1	2025
5079	0.007239600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280234	1	2025
5080	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280252	1	2025
5081	0.005140800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280269	1	2025
5082	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280287	1	2025
5083	0.001870350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280304	1	2025
5084	0.001944600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280322	1	2025
5085	0.015001500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28034	1	2025
5086	0.016938100000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280357	1	2025
5087	0.016437900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280375	1	2025
5088	0.016103650000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280393	1	2025
5089	0.017412200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280411	1	2025
5090	0.019070400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28043	1	2025
5091	0.018898050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280447	1	2025
5092	0.017197500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280465	1	2025
5093	0.017320550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280482	1	2025
5094	0.021981700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280499	1	2025
5095	0.019545500000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280517	1	2025
5096	0.018300750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280535	1	2025
5097	0.030436050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280552	1	2025
5098	0.027628300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28057	1	2025
5099	0.020618400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280587	1	2025
5100	0.026593900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280604	1	2025
5101	0.023595750000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280622	1	2025
5102	0.022980150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280639	1	2025
5103	0.023972050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280657	1	2025
5104	0.026147250000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280674	1	2025
5105	0.028465800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280691	1	2025
5106	0.040187850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280709	1	2025
5107	0.025360200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280727	1	2025
5108	0.041129650000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280744	1	2025
5109	0.019157700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280761	1	2025
5110	0.032919300000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280779	1	2025
5111	0.027552700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280796	1	2025
5112	0.031109850000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280817	1	2025
5113	0.033513150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280835	1	2025
5114	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280852	1	2025
5115	0.027819000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280869	1	2025
5116	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280887	1	2025
5117	0.010579200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280904	1	2025
5118	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280922	1	2025
5119	0.010382400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280939	1	2025
5120	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280957	1	2025
5121	0.006804000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280974	1	2025
5122	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.280992	1	2025
5123	0.019842550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281009	1	2025
5124	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281026	1	2025
5125	0.006985050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281044	1	2025
5126	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281061	1	2025
5127	0.013996800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281079	1	2025
5128	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281098	1	2025
5129	0.015951450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281116	1	2025
5130	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281133	1	2025
5131	0.008316000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28115	1	2025
5132	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281167	1	2025
5133	0.003664600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281186	1	2025
5134	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281204	1	2025
5135	0.004885800000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281222	1	2025
5136	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28124	1	2025
5137	0.004446000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281257	1	2025
5138	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281275	1	2025
5139	0.012003350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281292	1	2025
5140	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28131	1	2025
5141	0.014362550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281327	1	2025
5142	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281346	1	2025
5143	0.003753400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281364	1	2025
5144	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281382	1	2025
5145	0.007521050000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281399	1	2025
5146	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281416	1	2025
5147	0.005695000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281434	1	2025
5148	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281451	1	2025
5149	0.004695600000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281469	1	2025
5150	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281487	1	2025
5151	0.011398900000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281505	1	2025
5152	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281523	1	2025
5153	0.007574400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281541	1	2025
5154	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281559	1	2025
5155	0.006274550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281576	1	2025
5156	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281594	1	2025
5157	0.006235350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281612	1	2025
5158	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28163	1	2025
5159	0.004550400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281647	1	2025
5160	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281665	1	2025
5161	0.003782550000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281682	1	2025
5162	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.2817	1	2025
5163	0.003817150000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281717	1	2025
5164	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281734	1	2025
5165	0.004336700000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281753	1	2025
5166	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28177	1	2025
5167	0.002635200000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281787	1	2025
5168	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281805	1	2025
5169	0.001910350000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281825	1	2025
5170	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281843	1	2025
5171	0.000909450000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281872	1	2025
5172	0.000001900000000	USD	f	S4 LRS Disk Operations	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281889	1	2025
5173	0.000698400000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281907	1	2025
5174	0.424764000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281925	1	2025
5175	0.013752000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281943	1	2025
5176	0.013572000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281963	1	2025
5177	0.033192000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281981	1	2025
5178	0.012888000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.281999	1	2025
5179	0.010224000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282016	1	2025
5180	0.011772000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282034	1	2025
5181	0.015012000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282052	1	2025
5182	0.014112000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28207	1	2025
5183	0.008892000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282086	1	2025
5184	0.012492000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282103	1	2025
5185	0.006552000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282119	1	2025
5186	0.011088000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282135	1	2025
5187	0.021204000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282151	1	2025
5188	0.012348000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282167	1	2025
5189	0.012780000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282186	1	2025
5190	0.014436000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282203	1	2025
5191	0.016308000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282221	1	2025
5192	0.010512000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282238	1	2025
5193	0.011052000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282255	1	2025
5194	0.012060000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282271	1	2025
5195	0.016164000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282287	1	2025
5196	0.012276000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282303	1	2025
5197	0.013644000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282318	1	2025
5198	0.015480000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282335	1	2025
5199	0.012168000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282351	1	2025
5200	0.006192000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282367	1	2025
5201	0.013176000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282385	1	2025
5202	0.010764000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.2824	1	2025
5203	0.014076000000000	USD	f	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282417	1	2025
5204	0.996804000000000	USD	t	Snapshots ZRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.28243	\N	2025
5205	0.271548000000000	USD	t	Snapshots LRS Snapshots	11	SNAPSHOT	Storage	2026-04-17 09:47:09.282442	\N	2025
5206	0.000009444728494	USD	f	Intra Continent Data Transfer Out	11	VM	Bandwidth	2026-04-17 09:47:09.282465	1	2025
5207	0.473685920000000	USD	f	D2ls v5	11	VM	Virtual Machines	2026-04-17 09:47:09.282469	1	2025
5208	0.000000507384539	USD	f	Intra Continent Data Transfer Out	11	VM	Bandwidth	2026-04-17 09:47:09.282476	2	2025
5209	0.000013123601675	USD	f	Intra Continent Data Transfer Out	11	VM	Bandwidth	2026-04-17 09:47:09.282482	3	2025
5210	0.194000000000000	USD	f	D2ls v5	11	VM	Virtual Machines	2026-04-17 09:47:09.282485	3	2025
5211	0.000014918651432	USD	f	Intra Continent Data Transfer Out	11	VM	Bandwidth	2026-04-17 09:47:09.28249	4	2025
5212	0.000336979702115	USD	f	Intra Continent Data Transfer Out	11	VM	Bandwidth	2026-04-17 09:47:09.282495	5	2025
5213	0.000013509877026	USD	f	Intra Continent Data Transfer Out	11	VM	Bandwidth	2026-04-17 09:47:09.2825	6	2025
5214	2.929411640000000	USD	f	D2ls v5	11	VM	Virtual Machines	2026-04-17 09:47:09.282506	6	2025
5215	0.000009310618043	USD	f	Intra Continent Data Transfer Out	11	VM	Bandwidth	2026-04-17 09:47:09.282512	7	2025
5216	22.976101134000000	USD	f	D2ls v5	11	VM	Virtual Machines	2026-04-17 09:47:09.282516	7	2025
5217	0.300940860215054	USD	t	Alerts Metric Monitored	11	ALERT	Azure Monitor	2026-04-17 09:47:09.282536	\N	2025
5218	0.302016129032257	USD	t	Alerts Metric Monitored	11	ALERT	Azure Monitor	2026-04-17 09:47:09.282552	\N	2025
5219	0.260752688172043	USD	t	Alerts Metric Monitored	11	ALERT	Azure Monitor	2026-04-17 09:47:09.282567	\N	2025
5220	0.301075268817204	USD	t	Alerts Metric Monitored	11	ALERT	Azure Monitor	2026-04-17 09:47:09.282583	\N	2025
5221	0.281261797714978	USD	f	Standard Traffic Analytics Processing	11	NSG	Network Watcher	2026-04-17 09:47:09.282599	4	2025
5222	0.090060449671000	USD	t	Standard Traffic Analytics Processing	11	NSG	Network Watcher	2026-04-17 09:47:09.282617	\N	2025
5223	3.600000000000000	USD	t	Standard IPv4 Static Public IP	11	PUBLIC_IP	Virtual Network	2026-04-17 09:47:09.282644	\N	2025
5224	2.294126388888890	USD	f	Standard IPv4 Static Public IP	11	PUBLIC_IP	Virtual Network	2026-04-17 09:47:09.28266	2	2025
5225	3.600000000000000	USD	f	Standard IPv4 Static Public IP	11	PUBLIC_IP	Virtual Network	2026-04-17 09:47:09.282676	3	2025
5226	3.600000000000000	USD	f	Standard IPv4 Static Public IP	11	PUBLIC_IP	Virtual Network	2026-04-17 09:47:09.282692	4	2025
5227	3.600000000000000	USD	f	Standard IPv4 Static Public IP	11	PUBLIC_IP	Virtual Network	2026-04-17 09:47:09.282706	4	2025
5228	3.600000000000000	USD	f	Standard IPv4 Static Public IP	11	PUBLIC_IP	Virtual Network	2026-04-17 09:47:09.282721	6	2025
5229	1.450358429910000	USD	t	Analytics Logs Data Ingestion	11	LOG_ANALYTICS	Log Analytics	2026-04-17 09:47:09.282738	\N	2025
5230	5.117800089740000	USD	f	Analytics Logs Data Ingestion	11	LOG_ANALYTICS	Log Analytics	2026-04-17 09:47:09.282752	4	2025
5231	1.659300849830000	USD	f	Analytics Logs Data Ingestion	11	LOG_ANALYTICS	Log Analytics	2026-04-17 09:47:09.282768	6	2025
5232	0.000020860000000	USD	t	Intra Continent Data Transfer Out	11	STORAGE	Bandwidth	2026-04-17 09:47:09.282783	\N	2025
5233	0.000001300000000	USD	t	Account Encrypted Read Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282798	\N	2025
5234	0.001993480000000	USD	t	All Other Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282816	\N	2025
5235	0.003245090000000	USD	t	Cool Data Retrieval	11	STORAGE	Storage	2026-04-17 09:47:09.282831	\N	2025
5236	0.001013130000000	USD	t	Cool LRS Data Stored	11	STORAGE	Storage	2026-04-17 09:47:09.282845	\N	2025
5237	1.776650000000000	USD	t	Cool LRS Write Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282861	\N	2025
5238	0.003009000000000	USD	t	Cool Read Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282884	\N	2025
5239	0.055306800000000	USD	t	LRS List and Create Container Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282911	\N	2025
5240	0.000003000000000	USD	t	List Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282928	\N	2025
5241	0.000000600000000	USD	t	Read Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282943	\N	2025
5242	0.054963576000000	USD	t	Class 2 Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282963	\N	2025
5243	0.000024552000000	USD	t	Delete Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282979	\N	2025
5244	0.000938628000000	USD	t	LRS Class 1 Operations	11	STORAGE	Storage	2026-04-17 09:47:09.282994	\N	2025
5245	0.001682820000000	USD	t	LRS Data Stored	11	STORAGE	Storage	2026-04-17 09:47:09.283009	\N	2025
5246	0.000314100000000	USD	t	LRS List and Create Container Operations	11	STORAGE	Storage	2026-04-17 09:47:09.283023	\N	2025
5247	0.576884544000000	USD	t	LRS Write Operations	11	STORAGE	Storage	2026-04-17 09:47:09.283038	\N	2025
5248	0.000009000000000	USD	t	List Operations	11	STORAGE	Storage	2026-04-17 09:47:09.283052	\N	2025
5249	0.019863900000000	USD	t	Protocol Operations	11	STORAGE	Storage	2026-04-17 09:47:09.283067	\N	2025
5250	0.150574590000000	USD	t	Read Operations	11	STORAGE	Storage	2026-04-17 09:47:09.283083	\N	2025
5251	0.000000720000000	USD	t	Scan Operations	11	STORAGE	Storage	2026-04-17 09:47:09.283098	\N	2025
5252	0.000024660000000	USD	t	Write Operations	11	STORAGE	Storage	2026-04-17 09:47:09.283113	\N	2025
5253	167.000000000000000	USD	t	[RESERVATION] D2ls v5	10	RESERVATION	Virtual Machines	2026-04-17 09:49:55.252879	\N	2025
5254	47.830000000000000	USD	t	[RESERVATION] D2s v5	10	RESERVATION	Virtual Machines	2026-04-17 09:49:55.252901	\N	2025
5255	0.000053320000000	USD	t	All Other Operations	10	STORAGE	Storage	2026-04-17 09:49:55.252919	\N	2025
5256	0.299577600000000	USD	t	LRS Data Stored	10	STORAGE	Storage	2026-04-17 09:49:55.252935	\N	2025
5257	0.299683200000000	USD	t	Snapshots LRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.252956	\N	2025
5258	3.599769600000000	USD	t	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.252963	\N	2025
5259	1.368080800000000	USD	f	E10 ZRS Disk Operations	10	DISK	Storage	2026-04-17 09:49:55.252969	1	2025
5260	3.599769600000000	USD	f	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.252975	1	2025
5261	3.599769600000000	USD	f	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.252981	2	2025
5262	1.535901696000000	USD	f	S4 LRS Disk	10	DISK	Storage	2026-04-17 09:49:55.253007	2	2025
5263	0.019755300000000	USD	f	S4 LRS Disk Operations	10	DISK	Storage	2026-04-17 09:49:55.253039	2	2025
5264	2.644560800000000	USD	f	E10 ZRS Disk Operations	10	DISK	Storage	2026-04-17 09:49:55.253051	3	2025
5265	3.599769600000000	USD	f	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.253062	3	2025
5266	2.570496000000000	USD	f	E10 ZRS Disk Operations	10	DISK	Storage	2026-04-17 09:49:55.253073	4	2025
5267	3.599769600000000	USD	f	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.253084	4	2025
5268	3.599769600000000	USD	f	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.2531	4	2025
5269	0.998388200000000	USD	f	E10 ZRS Disk Operations	10	DISK	Storage	2026-04-17 09:49:55.253116	5	2025
5270	3.599769600000000	USD	f	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.253131	5	2025
5271	1.682581200000000	USD	f	E10 ZRS Disk Operations	10	DISK	Storage	2026-04-17 09:49:55.253143	7	2025
5272	3.599769600000000	USD	f	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.253153	7	2025
5273	2.767585600000000	USD	f	E10 ZRS Disk Operations	10	DISK	Storage	2026-04-17 09:49:55.253164	6	2025
5274	3.599769600000000	USD	f	E4 ZRS Disk	10	DISK	Storage	2026-04-17 09:49:55.253173	6	2025
5275	0.516373200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253203	1	2025
5276	0.001853600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253234	1	2025
5277	0.022279500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253254	1	2025
5278	0.022788900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253272	1	2025
5279	0.024510300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253289	1	2025
5280	0.026233700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253306	1	2025
5281	0.025763600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253323	1	2025
5282	0.022982300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253341	1	2025
5283	0.024514100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253358	1	2025
5284	0.024927600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253376	1	2025
5285	0.024976000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253395	1	2025
5286	0.026827900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253413	1	2025
5287	0.031055350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253431	1	2025
5288	0.033985000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253448	1	2025
5289	0.027240200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253465	1	2025
5290	0.028352400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253483	1	2025
5291	0.028005700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.2535	1	2025
5292	0.033661700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253518	1	2025
5293	0.030396800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253535	1	2025
5294	0.039376100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253553	1	2025
5295	0.081613000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253571	1	2025
5296	0.031858600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253588	1	2025
5297	0.026099250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253606	1	2025
5298	0.028393900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253623	1	2025
5299	0.034441400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253641	1	2025
5300	0.037921300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253658	1	2025
5301	0.073860200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253675	1	2025
5302	0.055654500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253693	1	2025
5303	0.027133000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253711	1	2025
5304	0.033887050000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253728	1	2025
5305	0.042281450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253746	1	2025
5306	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253764	1	2025
5307	0.036023300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253782	1	2025
5308	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253799	1	2025
5309	0.042089300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253828	1	2025
5310	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253846	1	2025
5311	0.033616800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253865	1	2025
5312	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253882	1	2025
5313	0.046939200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.2539	1	2025
5314	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253919	1	2025
5315	0.015552000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253937	1	2025
5316	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253956	1	2025
5317	0.004492800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253973	1	2025
5318	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.253991	1	2025
5319	0.007068200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254009	1	2025
5320	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254026	1	2025
5321	0.018691200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254043	1	2025
5322	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254061	1	2025
5323	0.017305200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254078	1	2025
5324	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254096	1	2025
5325	0.012516250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254114	1	2025
5326	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254131	1	2025
5327	0.023234400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254148	1	2025
5328	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254166	1	2025
5329	0.004392000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254183	1	2025
5330	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254201	1	2025
5331	0.003306000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254219	1	2025
5332	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254237	1	2025
5333	0.009374400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254254	1	2025
5334	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254271	1	2025
5335	0.008180400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254288	1	2025
5336	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254306	1	2025
5337	0.013113600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254323	1	2025
5338	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254341	1	2025
5339	0.014634000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254358	1	2025
5340	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254376	1	2025
5341	0.012700800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254394	1	2025
5342	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254411	1	2025
5343	0.004492800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254428	1	2025
5344	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254445	1	2025
5345	0.003268800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254463	1	2025
5346	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25448	1	2025
5347	0.004303200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254498	1	2025
5348	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254517	1	2025
5349	0.006924000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254534	1	2025
5350	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254551	1	2025
5351	0.006976800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254569	1	2025
5352	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254586	1	2025
5353	0.007411200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254604	1	2025
5354	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254621	1	2025
5355	0.006955550000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254639	1	2025
5356	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25466	1	2025
5357	0.007718400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254688	1	2025
5358	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254717	1	2025
5359	0.004690900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254747	1	2025
5360	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25477	1	2025
5361	0.003216000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254799	1	2025
5362	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254828	1	2025
5363	0.002487600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25485	1	2025
5364	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254868	1	2025
5365	0.001041600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254885	1	2025
5366	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254902	1	2025
5367	0.000992400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254925	1	2025
5368	0.017598450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254947	1	2025
5369	0.018888350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254965	1	2025
5370	0.019624450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254982	1	2025
5371	0.022788550000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.254999	1	2025
5372	0.020813750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255017	1	2025
5373	0.020983050000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255034	1	2025
5374	0.019743350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255052	1	2025
5375	0.020625500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255069	1	2025
5376	0.023026500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255086	1	2025
5377	0.023664050000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255104	1	2025
5378	0.023308050000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255121	1	2025
5379	0.024393050000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255139	1	2025
5380	0.025816800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255156	1	2025
5381	0.022419850000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255173	1	2025
5382	0.024697400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25519	1	2025
5383	0.027228200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255207	1	2025
5384	0.009894500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255224	1	2025
5385	0.028215350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255242	1	2025
5386	0.047008600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25526	1	2025
5387	0.032693900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255277	1	2025
5388	0.026529950000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255294	1	2025
5389	0.027721000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255312	1	2025
5390	0.030026350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25533	1	2025
5391	0.036772350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255347	1	2025
5392	0.042699950000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255365	1	2025
5393	0.058494200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255382	1	2025
5394	0.044960050000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255399	1	2025
5395	0.040747850000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255417	1	2025
5396	0.036332250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255434	1	2025
5397	0.042144050000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255452	1	2025
5398	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25547	1	2025
5399	0.048175250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255487	1	2025
5400	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255504	1	2025
5401	0.021929500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255522	1	2025
5402	0.000002000000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25554	1	2025
5403	0.016947600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255557	1	2025
5404	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255574	1	2025
5405	0.016766400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255592	1	2025
5406	0.000002000000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255609	1	2025
5407	0.016110300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255627	1	2025
5408	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255644	1	2025
5409	0.006946450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255661	1	2025
5410	0.000002000000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255679	1	2025
5411	0.010829400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255696	1	2025
5412	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255714	1	2025
5413	0.016243750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255732	1	2025
5414	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255749	1	2025
5415	0.014434800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255766	1	2025
5416	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255784	1	2025
5417	0.011942850000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255801	1	2025
5418	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255825	1	2025
5419	0.008316000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255843	1	2025
5420	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255861	1	2025
5421	0.006035400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255879	1	2025
5422	0.000002000000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255897	1	2025
5423	0.008458800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255916	1	2025
5424	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255934	1	2025
5425	0.008296750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255952	1	2025
5426	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25597	1	2025
5427	0.009832800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.255988	1	2025
5428	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256011	1	2025
5429	0.012288000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256041	1	2025
5430	0.000002050000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25607	1	2025
5431	0.007866000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.2561	1	2025
5432	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256118	1	2025
5433	0.008265600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256136	1	2025
5434	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256153	1	2025
5435	0.003566550000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256173	1	2025
5436	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256194	1	2025
5437	0.003206000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256211	1	2025
5438	0.000002000000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256229	1	2025
5439	0.005029200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256247	1	2025
5440	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256267	1	2025
5441	0.007872000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256285	1	2025
5442	0.000002000000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256303	1	2025
5443	0.006353250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25632	1	2025
5444	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256338	1	2025
5445	0.004924800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256355	1	2025
5446	0.000002000000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256372	1	2025
5447	0.004006800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25639	1	2025
5448	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256408	1	2025
5449	0.012254400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256425	1	2025
5450	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256443	1	2025
5451	0.002048700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25646	1	2025
5452	0.000002000000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256477	1	2025
5453	0.002793600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256496	1	2025
5454	0.000001800000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256513	1	2025
5455	0.002088000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256531	1	2025
5456	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256548	1	2025
5457	0.001190400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256565	1	2025
5458	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256583	1	2025
5459	0.000690000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256601	1	2025
5460	0.002182600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256619	1	2025
5461	0.026249900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256637	1	2025
5462	0.026864500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256654	1	2025
5463	0.028873300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256671	1	2025
5464	0.028045200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256689	1	2025
5465	0.028520600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256706	1	2025
5466	0.028795600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256724	1	2025
5467	0.029167800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256741	1	2025
5468	0.028719450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256759	1	2025
5469	0.030493000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256776	1	2025
5470	0.032153000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256794	1	2025
5471	0.031064800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256818	1	2025
5472	0.034823750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256836	1	2025
5473	0.032325400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256853	1	2025
5474	0.032901800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25687	1	2025
5475	0.031980350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256888	1	2025
5476	0.039692150000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256905	1	2025
5477	0.036422850000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256922	1	2025
5478	0.036295450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256941	1	2025
5479	0.035798900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256958	1	2025
5480	0.035813500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256976	1	2025
5481	0.036946500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.256997	1	2025
5482	0.038764700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257015	1	2025
5483	0.044136500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257032	1	2025
5484	0.050992500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257049	1	2025
5485	0.051895550000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257066	1	2025
5486	0.055648250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257084	1	2025
5487	0.049340000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257101	1	2025
5488	0.049355000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25712	1	2025
5489	0.051948450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257137	1	2025
5490	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257154	1	2025
5491	0.057475600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257172	1	2025
5492	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257189	1	2025
5493	0.050796500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257208	1	2025
5494	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257225	1	2025
5495	0.039283500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257242	1	2025
5496	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257259	1	2025
5497	0.016036900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257276	1	2025
5498	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257295	1	2025
5499	0.014702800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257312	1	2025
5500	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257329	1	2025
5501	0.012460000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257346	1	2025
5502	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257364	1	2025
5503	0.011437800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257381	1	2025
5504	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257399	1	2025
5505	0.016645450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257416	1	2025
5506	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257433	1	2025
5507	0.017551800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25745	1	2025
5508	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257468	1	2025
5509	0.019199000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257485	1	2025
5510	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257502	1	2025
5511	0.007862400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257519	1	2025
5512	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257536	1	2025
5513	0.010608000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257554	1	2025
5514	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257572	1	2025
5515	0.009348000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257589	1	2025
5516	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257607	1	2025
5517	0.009028800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257624	1	2025
5518	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257641	1	2025
5519	0.020277600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257658	1	2025
5520	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257675	1	2025
5521	0.011558400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257692	1	2025
5522	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25771	1	2025
5523	0.008118000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257728	1	2025
5524	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257745	1	2025
5525	0.008777000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257762	1	2025
5526	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257779	1	2025
5527	0.006358250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257796	1	2025
5528	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257817	1	2025
5529	0.005270400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257835	1	2025
5530	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257852	1	2025
5531	0.006558100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257874	1	2025
5532	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257891	1	2025
5533	0.012705450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257909	1	2025
5534	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257926	1	2025
5535	0.006426000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257943	1	2025
5536	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25796	1	2025
5537	0.006044400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257978	1	2025
5538	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.257995	1	2025
5539	0.003847200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258012	1	2025
5540	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25803	1	2025
5541	0.008676000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258047	1	2025
5542	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258064	1	2025
5543	0.002328000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258082	1	2025
5544	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258099	1	2025
5545	0.002664000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258116	1	2025
5546	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258133	1	2025
5547	0.003110400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258151	1	2025
5548	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258169	1	2025
5549	0.001207900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258186	1	2025
5550	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258203	1	2025
5551	0.000672600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25822	1	2025
5552	0.002001800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258238	1	2025
5553	0.023929900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258256	1	2025
5554	0.024533500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258274	1	2025
5555	0.029004600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258292	1	2025
5556	0.027213600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258309	1	2025
5557	0.035841900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258328	1	2025
5558	0.030769400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258346	1	2025
5559	0.026131900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258364	1	2025
5560	0.026956100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258381	1	2025
5561	0.027166950000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258399	1	2025
5562	0.028994150000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258416	1	2025
5563	0.044873150000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258434	1	2025
5564	0.051448500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258451	1	2025
5565	0.037998400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258468	1	2025
5566	0.031346300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258486	1	2025
5567	0.031006500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258503	1	2025
5568	0.036612000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258521	1	2025
5569	0.032799900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258539	1	2025
5570	0.073027350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258556	1	2025
5571	0.078178600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258573	1	2025
5572	0.061044150000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25859	1	2025
5573	0.032643900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258609	1	2025
5574	0.036772400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258627	1	2025
5575	0.045245800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258644	1	2025
5576	0.049627100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258662	1	2025
5577	0.089216300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258679	1	2025
5578	0.111410100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258697	1	2025
5579	0.071924300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258715	1	2025
5580	0.041959100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258732	1	2025
5581	0.066038800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258749	1	2025
5582	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258767	1	2025
5583	0.051269000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258786	1	2025
5584	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258804	1	2025
5585	0.052438400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258826	1	2025
5586	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258843	1	2025
5587	0.092359200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25886	1	2025
5588	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258878	1	2025
5589	0.080803050000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258896	1	2025
5590	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258915	1	2025
5591	0.012992400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258933	1	2025
5592	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258953	1	2025
5593	0.004992000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25897	1	2025
5594	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.258989	1	2025
5595	0.019707100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259007	1	2025
5596	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259024	1	2025
5597	0.020096250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259042	1	2025
5598	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259059	1	2025
5599	0.026695950000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259077	1	2025
5600	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259094	1	2025
5601	0.039551350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259111	1	2025
5602	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259129	1	2025
5603	0.029584800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259148	1	2025
5604	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259165	1	2025
5605	0.028584000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259182	1	2025
5606	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.2592	1	2025
5607	0.008116800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259218	1	2025
5608	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259235	1	2025
5609	0.014528700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259252	1	2025
5610	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25927	1	2025
5611	0.029821900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259288	1	2025
5612	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259305	1	2025
5613	0.016377600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259322	1	2025
5614	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259339	1	2025
5615	0.041670000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259356	1	2025
5616	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259373	1	2025
5617	0.039246750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259391	1	2025
5618	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259409	1	2025
5619	0.005085600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259426	1	2025
5620	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259445	1	2025
5621	0.007488000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259462	1	2025
5622	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25948	1	2025
5623	0.009372000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259497	1	2025
5624	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259515	1	2025
5625	0.014580000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259532	1	2025
5626	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259549	1	2025
5627	0.007256250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259566	1	2025
5628	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259584	1	2025
5629	0.017068800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259602	1	2025
5630	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25962	1	2025
5631	0.012894000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259637	1	2025
5632	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259654	1	2025
5633	0.014882400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259671	1	2025
5634	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259689	1	2025
5635	0.003815600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259707	1	2025
5636	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259724	1	2025
5637	0.004203700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259743	1	2025
5638	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25976	1	2025
5639	0.002066400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259791	1	2025
5640	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259808	1	2025
5641	0.001408800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259829	1	2025
5642	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259846	1	2025
5643	0.002200800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259864	1	2025
5644	0.001259900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259881	1	2025
5645	0.014809100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259902	1	2025
5646	0.014904550000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.25992	1	2025
5647	0.016826550000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259937	1	2025
5648	0.018264600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259954	1	2025
5649	0.016782100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259971	1	2025
5650	0.016833600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.259989	1	2025
5651	0.017217800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260006	1	2025
5652	0.015418000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260025	1	2025
5653	0.018627100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260042	1	2025
5654	0.017514850000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26006	1	2025
5655	0.018914750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260078	1	2025
5656	0.021312000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260096	1	2025
5657	0.020057900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260113	1	2025
5658	0.017609600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26013	1	2025
5659	0.019771400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260147	1	2025
5660	0.021975000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260164	1	2025
5661	0.022120500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260181	1	2025
5662	0.024253100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260199	1	2025
5663	0.024947900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260217	1	2025
5664	0.023058100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260234	1	2025
5665	0.023123800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260251	1	2025
5666	0.024204100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260269	1	2025
5667	0.026259600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260287	1	2025
5668	0.031546000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260305	1	2025
5669	0.032393900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260322	1	2025
5670	0.026031100000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260339	1	2025
5671	0.024825200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260357	1	2025
5672	0.019354400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260375	1	2025
5673	0.020637600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260392	1	2025
5674	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260409	1	2025
5675	0.028425600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260426	1	2025
5676	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260444	1	2025
5677	0.029838200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260461	1	2025
5678	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260479	1	2025
5679	0.017939900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260498	1	2025
5680	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260516	1	2025
5681	0.023115950000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260533	1	2025
5682	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26055	1	2025
5683	0.010627200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260568	1	2025
5684	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260586	1	2025
5685	0.009500750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260615	1	2025
5686	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260632	1	2025
5687	0.010823800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260649	1	2025
5688	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260667	1	2025
5689	0.012908750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260684	1	2025
5690	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260701	1	2025
5691	0.011990000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260719	1	2025
5692	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260736	1	2025
5693	0.005338900000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260753	1	2025
5694	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260771	1	2025
5695	0.006350400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260788	1	2025
5696	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260805	1	2025
5697	0.013392000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260826	1	2025
5698	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260844	1	2025
5699	0.007113600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260861	1	2025
5700	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260878	1	2025
5701	0.003433500000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260896	1	2025
5702	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260915	1	2025
5703	0.019126450000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260932	1	2025
5704	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260949	1	2025
5705	0.010963200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260967	1	2025
5706	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.260984	1	2025
5707	0.003824700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261003	1	2025
5708	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26102	1	2025
5709	0.007217850000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261037	1	2025
5710	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261054	1	2025
5711	0.004960800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261072	1	2025
5712	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261089	1	2025
5713	0.004319350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261107	1	2025
5714	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261124	1	2025
5715	0.005106700000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261141	1	2025
5716	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261159	1	2025
5717	0.006130350000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261178	1	2025
5718	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261196	1	2025
5719	0.006224250000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261213	1	2025
5720	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261232	1	2025
5721	0.008819300000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26125	1	2025
5722	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261267	1	2025
5723	0.003536400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261284	1	2025
5724	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261302	1	2025
5725	0.006069600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261319	1	2025
5726	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261336	1	2025
5727	0.001062000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261354	1	2025
5728	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261371	1	2025
5729	0.002798400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261388	1	2025
5730	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261406	1	2025
5731	0.001228750000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261423	1	2025
5732	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261441	1	2025
5733	0.001052800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261459	1	2025
5734	0.000001900000000	USD	f	S4 LRS Disk Operations	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261477	1	2025
5735	0.000600000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261494	1	2025
5736	0.424749600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261512	1	2025
5737	0.013764000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26153	1	2025
5738	0.013578000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261547	1	2025
5739	0.033219600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261564	1	2025
5740	0.012908400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261583	1	2025
5741	0.010192800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261601	1	2025
5742	0.011792400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261619	1	2025
5743	0.015028800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261636	1	2025
5744	0.014136000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261654	1	2025
5745	0.008890800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261672	1	2025
5746	0.012462000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261689	1	2025
5747	0.006547200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261706	1	2025
5748	0.011085600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261724	1	2025
5749	0.021204000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261741	1	2025
5750	0.012350400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261758	1	2025
5751	0.012759600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261775	1	2025
5752	0.014433600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261792	1	2025
5753	0.016293600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261813	1	2025
5754	0.010527600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26183	1	2025
5755	0.011048400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261848	1	2025
5756	0.012090000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261866	1	2025
5757	0.016144800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261885	1	2025
5758	0.012276000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261903	1	2025
5759	0.013652400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26192	1	2025
5760	0.015475200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261937	1	2025
5761	0.012164400000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261954	1	2025
5762	0.006175200000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.261973	1	2025
5763	0.013168800000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.26199	1	2025
5764	0.010788000000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.262007	1	2025
5765	0.014061600000000	USD	f	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.262025	1	2025
5766	0.996811200000000	USD	t	Snapshots ZRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.262048	\N	2025
5767	0.271522800000000	USD	t	Snapshots LRS Snapshots	10	SNAPSHOT	Storage	2026-04-17 09:49:55.262076	\N	2025
5768	0.000009768828750	USD	f	Intra Continent Data Transfer Out	10	VM	Bandwidth	2026-04-17 09:49:55.262098	1	2025
5769	1.215735920000000	USD	f	D2ls v5	10	VM	Virtual Machines	2026-04-17 09:49:55.262104	1	2025
5770	0.000018931552768	USD	f	Intra Continent Data Transfer Out	10	VM	Bandwidth	2026-04-17 09:49:55.262111	3	2025
5771	0.097000000000000	USD	f	D2ls v5	10	VM	Virtual Machines	2026-04-17 09:49:55.262115	3	2025
5772	0.000014495830983	USD	f	Intra Continent Data Transfer Out	10	VM	Bandwidth	2026-04-17 09:49:55.262121	4	2025
5773	0.000057325661182	USD	f	Intra Continent Data Transfer Out	10	VM	Bandwidth	2026-04-17 09:49:55.262126	5	2025
5774	1.393571258000000	USD	f	D2ls v5	10	VM	Virtual Machines	2026-04-17 09:49:55.26213	5	2025
5775	0.000017681196332	USD	f	Intra Continent Data Transfer Out	10	VM	Bandwidth	2026-04-17 09:49:55.262135	6	2025
5776	0.000009795650840	USD	f	Intra Continent Data Transfer Out	10	VM	Bandwidth	2026-04-17 09:49:55.26214	7	2025
5777	22.851628212000000	USD	f	D2ls v5	10	VM	Virtual Machines	2026-04-17 09:49:55.262143	7	2025
5778	0.324193548387097	USD	t	Alerts Metric Monitored	10	ALERT	Azure Monitor	2026-04-17 09:49:55.262163	\N	2025
5779	0.323655913978495	USD	t	Alerts Metric Monitored	10	ALERT	Azure Monitor	2026-04-17 09:49:55.262179	\N	2025
5780	0.276881720430108	USD	t	Alerts Metric Monitored	10	ALERT	Azure Monitor	2026-04-17 09:49:55.262195	\N	2025
5781	0.324462365591398	USD	t	Alerts Metric Monitored	10	ALERT	Azure Monitor	2026-04-17 09:49:55.262212	\N	2025
5782	0.387857842817903	USD	f	Standard Traffic Analytics Processing	10	NSG	Network Watcher	2026-04-17 09:49:55.262229	4	2025
5783	0.133654462173581	USD	t	Standard Traffic Analytics Processing	10	NSG	Network Watcher	2026-04-17 09:49:55.262246	\N	2025
5784	3.720000000000000	USD	t	Standard IPv4 Static Public IP	10	PUBLIC_IP	Virtual Network	2026-04-17 09:49:55.262261	\N	2025
5785	3.720000000000000	USD	f	Standard IPv4 Static Public IP	10	PUBLIC_IP	Virtual Network	2026-04-17 09:49:55.262276	3	2025
5786	3.720000000000000	USD	f	Standard IPv4 Static Public IP	10	PUBLIC_IP	Virtual Network	2026-04-17 09:49:55.262291	4	2025
5787	3.720000000000000	USD	f	Standard IPv4 Static Public IP	10	PUBLIC_IP	Virtual Network	2026-04-17 09:49:55.262311	4	2025
5788	3.720000000000000	USD	f	Standard IPv4 Static Public IP	10	PUBLIC_IP	Virtual Network	2026-04-17 09:49:55.262326	6	2025
5789	1.573603891730000	USD	t	Analytics Logs Data Ingestion	10	LOG_ANALYTICS	Log Analytics	2026-04-17 09:49:55.262342	\N	2025
5790	5.484979406270000	USD	f	Analytics Logs Data Ingestion	10	LOG_ANALYTICS	Log Analytics	2026-04-17 09:49:55.262358	4	2025
5791	1.745914287780000	USD	f	Analytics Logs Data Ingestion	10	LOG_ANALYTICS	Log Analytics	2026-04-17 09:49:55.262372	6	2025
5792	0.000005340000000	USD	t	Intra Continent Data Transfer Out	10	STORAGE	Bandwidth	2026-04-17 09:49:55.262387	\N	2025
5793	0.001983590000000	USD	t	All Other Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262401	\N	2025
5794	0.004549410000000	USD	t	Cool Data Retrieval	10	STORAGE	Storage	2026-04-17 09:49:55.262414	\N	2025
5795	0.001841660000000	USD	t	Cool LRS Data Stored	10	STORAGE	Storage	2026-04-17 09:49:55.262428	\N	2025
5796	1.814880000000000	USD	t	Cool LRS Write Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262443	\N	2025
5797	0.003003000000000	USD	t	Cool Read Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262457	\N	2025
5798	0.036271800000000	USD	t	LRS List and Create Container Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262471	\N	2025
5799	0.056819160000000	USD	t	Class 2 Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262486	\N	2025
5800	0.000025344000000	USD	t	Delete Operations	10	STORAGE	Storage	2026-04-17 09:49:55.2625	\N	2025
5801	0.000970488000000	USD	t	LRS Class 1 Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262514	\N	2025
5802	0.001676280000000	USD	t	LRS Data Stored	10	STORAGE	Storage	2026-04-17 09:49:55.262529	\N	2025
5803	0.000324360000000	USD	t	LRS List and Create Container Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262545	\N	2025
5804	0.603147456000000	USD	t	LRS Write Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262558	\N	2025
5805	0.020927550000000	USD	t	Protocol Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262572	\N	2025
5806	0.156074466000000	USD	t	Read Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262586	\N	2025
5807	0.000000720000000	USD	t	Scan Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262601	\N	2025
5808	0.000025488000000	USD	t	Write Operations	10	STORAGE	Storage	2026-04-17 09:49:55.262615	\N	2025
5809	167.000000000000000	USD	t	[RESERVATION] D2ls v5	9	RESERVATION	Virtual Machines	2026-04-17 10:02:46.708549	\N	2025
5810	47.830000000000000	USD	t	[RESERVATION] D2s v5	9	RESERVATION	Virtual Machines	2026-04-17 10:02:46.708569	\N	2025
5811	0.000062350000000	USD	t	All Other Operations	9	STORAGE	Storage	2026-04-17 10:02:46.708587	\N	2025
5812	0.299980800000000	USD	t	LRS Data Stored	9	STORAGE	Storage	2026-04-17 10:02:46.708605	\N	2025
5813	0.000015000000000	USD	t	Operations	9	OTHER	Key Vault	2026-04-17 10:02:46.708634	\N	2025
5814	0.299664000000000	USD	t	Snapshots LRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708655	\N	2025
5815	1.886914800000000	USD	t	E10 ZRS Disk Operations	9	DISK	Storage	2026-04-17 10:02:46.708662	\N	2025
5816	3.600288000000000	USD	t	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708668	\N	2025
5817	1.191013000000000	USD	f	E10 ZRS Disk Operations	9	DISK	Storage	2026-04-17 10:02:46.708674	1	2025
5818	3.600288000000000	USD	f	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708681	1	2025
5819	3.600288000000000	USD	f	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708687	2	2025
5820	1.536122880000000	USD	f	S4 LRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708707	2	2025
5821	0.011083000000000	USD	f	S4 LRS Disk Operations	9	DISK	Storage	2026-04-17 10:02:46.708724	2	2025
5822	2.597344400000000	USD	f	E10 ZRS Disk Operations	9	DISK	Storage	2026-04-17 10:02:46.70873	3	2025
5823	3.600288000000000	USD	f	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708736	3	2025
5824	2.531514200000000	USD	f	E10 ZRS Disk Operations	9	DISK	Storage	2026-04-17 10:02:46.708743	4	2025
5825	3.600288000000000	USD	f	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708748	4	2025
5826	3.600288000000000	USD	f	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708758	4	2025
5827	0.939772400000000	USD	f	E10 ZRS Disk Operations	9	DISK	Storage	2026-04-17 10:02:46.708768	5	2025
5828	3.600288000000000	USD	f	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708775	5	2025
5829	1.516820400000000	USD	f	E10 ZRS Disk Operations	9	DISK	Storage	2026-04-17 10:02:46.708781	7	2025
5830	3.600288000000000	USD	f	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708787	7	2025
5831	2.689664200000000	USD	f	E10 ZRS Disk Operations	9	DISK	Storage	2026-04-17 10:02:46.708793	6	2025
5832	3.600288000000000	USD	f	E4 ZRS Disk	9	DISK	Storage	2026-04-17 10:02:46.708799	6	2025
5833	0.516348000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708844	1	2025
5834	0.002917800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708862	1	2025
5835	0.034842300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708881	1	2025
5836	0.033558750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708899	1	2025
5837	0.037259050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708916	1	2025
5838	0.035494550000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708934	1	2025
5839	0.038048250000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708952	1	2025
5840	0.039721300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.70897	1	2025
5841	0.048236750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.708988	1	2025
5842	0.037972200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709006	1	2025
5843	0.038282400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709023	1	2025
5844	0.025347900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709048	1	2025
5845	0.030250300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709066	1	2025
5846	0.027494000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709083	1	2025
5847	0.032902900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.7091	1	2025
5848	0.041148800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709129	1	2025
5849	0.028596200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709157	1	2025
5850	0.032626200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709175	1	2025
5851	0.028458800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709193	1	2025
5852	0.030710300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.70921	1	2025
5853	0.035196550000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709228	1	2025
5854	0.038628400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709245	1	2025
5855	0.052126900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709263	1	2025
5856	0.033890600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709281	1	2025
5857	0.031501200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709298	1	2025
5858	0.028348700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709315	1	2025
5859	0.033728600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709333	1	2025
5860	0.036018400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709351	1	2025
5861	0.052299800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709369	1	2025
5862	0.053271200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709386	1	2025
5863	0.034536700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709404	1	2025
5864	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709422	1	2025
5865	0.035192750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.70944	1	2025
5866	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709458	1	2025
5867	0.012197250000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709476	1	2025
5868	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709494	1	2025
5869	0.014460050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709511	1	2025
5870	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709529	1	2025
5871	0.028565050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709546	1	2025
5872	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709564	1	2025
5873	0.034085500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709582	1	2025
5874	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.7096	1	2025
5875	0.021444200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709618	1	2025
5876	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709636	1	2025
5877	0.003888000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709653	1	2025
5878	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709671	1	2025
5879	0.008362800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709689	1	2025
5880	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709706	1	2025
5881	0.008184000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709724	1	2025
5882	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709742	1	2025
5883	0.009475200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709759	1	2025
5884	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709777	1	2025
5885	0.008023250000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709794	1	2025
5886	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.70982	1	2025
5887	0.018582000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709837	1	2025
5888	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709855	1	2025
5889	0.017755200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709872	1	2025
5890	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709889	1	2025
5891	0.006837600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709914	1	2025
5892	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709931	1	2025
5893	0.007353600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709949	1	2025
5894	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709966	1	2025
5895	0.006048000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.709983	1	2025
5896	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710001	1	2025
5897	0.008887200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710018	1	2025
5898	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710035	1	2025
5899	0.006536400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710053	1	2025
5900	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71007	1	2025
5901	0.013449600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710088	1	2025
5902	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710105	1	2025
5903	0.036801600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710123	1	2025
5904	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71014	1	2025
5905	0.004140000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710159	1	2025
5906	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710177	1	2025
5907	0.001846800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710195	1	2025
5908	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710213	1	2025
5909	0.002102400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71023	1	2025
5910	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710248	1	2025
5911	0.003662400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710265	1	2025
5912	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710283	1	2025
5913	0.003938400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.7103	1	2025
5914	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710318	1	2025
5915	0.010950000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710336	1	2025
5916	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710354	1	2025
5917	0.005400000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710372	1	2025
5918	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710403	1	2025
5919	0.000529200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710421	1	2025
5920	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710439	1	2025
5921	0.000914400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710457	1	2025
5922	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710474	1	2025
5923	0.000679200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710492	1	2025
5924	0.018251650000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71051	1	2025
5925	0.018695550000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710531	1	2025
5926	0.019909600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710548	1	2025
5927	0.020641100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710566	1	2025
5928	0.021284700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710584	1	2025
5929	0.021637600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710601	1	2025
5930	0.022107900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710618	1	2025
5931	0.022444300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710635	1	2025
5932	0.024260000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710652	1	2025
5933	0.023128000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71067	1	2025
5934	0.025067200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710687	1	2025
5935	0.026251000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710706	1	2025
5936	0.023627700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710723	1	2025
5937	0.025696600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710741	1	2025
5938	0.030875250000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710758	1	2025
5939	0.025576100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710776	1	2025
5940	0.027149000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710793	1	2025
5941	0.028436200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710818	1	2025
5942	0.031691300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710845	1	2025
5943	0.039698300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710863	1	2025
5944	0.034738650000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71088	1	2025
5945	0.032376050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710897	1	2025
5946	0.032127900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710914	1	2025
5947	0.029085350000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710932	1	2025
5948	0.033043750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710951	1	2025
5949	0.031495350000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710967	1	2025
5950	0.036054400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710983	1	2025
5951	0.039923550000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.710999	1	2025
5952	0.034334000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711015	1	2025
5953	0.033296500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711032	1	2025
5954	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711049	1	2025
5955	0.014436000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711065	1	2025
5956	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711082	1	2025
5957	0.015277200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711098	1	2025
5958	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711114	1	2025
5959	0.017714400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71113	1	2025
5960	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711146	1	2025
5961	0.039819600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711163	1	2025
5962	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711179	1	2025
5963	0.015631200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711195	1	2025
5964	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711211	1	2025
5965	0.012750000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711228	1	2025
5966	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711244	1	2025
5967	0.005865000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71126	1	2025
5968	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711284	1	2025
5969	0.009742800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711303	1	2025
5970	0.000001800000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711334	1	2025
5971	0.010533600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711352	1	2025
5972	0.000002000000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71137	1	2025
5973	0.012375000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711388	1	2025
5974	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711406	1	2025
5975	0.009492700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711428	1	2025
5976	0.000001800000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711446	1	2025
5977	0.010442400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711464	1	2025
5978	0.000002000000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711481	1	2025
5979	0.011234250000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711499	1	2025
5980	0.000001800000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711516	1	2025
5981	0.005446800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711534	1	2025
5982	0.000002000000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711552	1	2025
5983	0.008217600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711569	1	2025
5984	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711586	1	2025
5985	0.006606000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711604	1	2025
5986	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711622	1	2025
5987	0.008915700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711639	1	2025
5988	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711657	1	2025
5989	0.008049600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711674	1	2025
5990	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711692	1	2025
5991	0.008802750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71171	1	2025
5992	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711727	1	2025
5993	0.007547950000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711745	1	2025
5994	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711762	1	2025
5995	0.004512000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71178	1	2025
5996	0.000001800000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711798	1	2025
5997	0.004060800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711824	1	2025
5998	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711853	1	2025
5999	0.004300800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71188	1	2025
6000	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711922	1	2025
6001	0.005703600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711949	1	2025
6002	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711969	1	2025
6003	0.006199200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.711998	1	2025
6004	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712035	1	2025
6005	0.008160000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712054	1	2025
6006	0.000002000000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712075	1	2025
6007	0.004084800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712092	1	2025
6008	0.000001800000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71211	1	2025
6009	0.002451600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712128	1	2025
6010	0.000002000000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712146	1	2025
6011	0.001257600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712163	1	2025
6012	0.000001800000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712182	1	2025
6013	0.000801600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.7122	1	2025
6014	0.001427850000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712217	1	2025
6015	0.035652300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712235	1	2025
6016	0.033306850000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712252	1	2025
6017	0.036667500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71227	1	2025
6018	0.034846550000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712288	1	2025
6019	0.038025000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712306	1	2025
6020	0.035534850000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712334	1	2025
6021	0.038982000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712366	1	2025
6022	0.038063300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712394	1	2025
6023	0.038376400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712424	1	2025
6024	0.034098700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712452	1	2025
6025	0.030293200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712495	1	2025
6026	0.033135750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712527	1	2025
6027	0.033555900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712554	1	2025
6028	0.033966300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712585	1	2025
6029	0.036723700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712619	1	2025
6030	0.034604400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712666	1	2025
6031	0.034430300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712687	1	2025
6032	0.038997000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712706	1	2025
6033	0.044917600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712728	1	2025
6034	0.039562900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712747	1	2025
6035	0.042923100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712779	1	2025
6036	0.038243100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712798	1	2025
6037	0.038397600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712823	1	2025
6038	0.037331000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712855	1	2025
6039	0.039802700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712872	1	2025
6040	0.043397200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712891	1	2025
6041	0.046062800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712909	1	2025
6042	0.046489000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712926	1	2025
6043	0.042769000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712946	1	2025
6044	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712964	1	2025
6045	0.041233350000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71298	1	2025
6046	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.712997	1	2025
6047	0.014178000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713013	1	2025
6048	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713029	1	2025
6049	0.016699200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713045	1	2025
6050	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713061	1	2025
6051	0.034905650000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713078	1	2025
6052	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713094	1	2025
6053	0.015450400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71311	1	2025
6054	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713128	1	2025
6055	0.014166350000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713146	1	2025
6056	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713169	1	2025
6057	0.012247500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713187	1	2025
6058	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713203	1	2025
6059	0.011102650000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71323	1	2025
6060	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713259	1	2025
6061	0.011172400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713286	1	2025
6062	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713313	1	2025
6063	0.011138400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713342	1	2025
6064	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713371	1	2025
6065	0.010633800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713416	1	2025
6066	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713443	1	2025
6067	0.011217600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71347	1	2025
6068	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713498	1	2025
6069	0.012268800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713524	1	2025
6070	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713551	1	2025
6071	0.008547000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713577	1	2025
6072	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713604	1	2025
6073	0.008119600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713632	1	2025
6074	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713665	1	2025
6075	0.007272000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713692	1	2025
6076	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71372	1	2025
6077	0.009487700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71375	1	2025
6078	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713782	1	2025
6079	0.009116100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713818	1	2025
6080	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713848	1	2025
6081	0.007820750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713878	1	2025
6082	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713908	1	2025
6083	0.005786000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713939	1	2025
6084	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713968	1	2025
6085	0.004971200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.713996	1	2025
6086	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714043	1	2025
6087	0.004773000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714062	1	2025
6088	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714085	1	2025
6089	0.004752000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714103	1	2025
6090	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71412	1	2025
6091	0.005628200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714137	1	2025
6092	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714155	1	2025
6093	0.006408000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714173	1	2025
6094	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714201	1	2025
6095	0.005459300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714249	1	2025
6096	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714282	1	2025
6097	0.004416000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714301	1	2025
6098	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714319	1	2025
6099	0.002521350000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714336	1	2025
6100	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71436	1	2025
6101	0.001685800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714378	1	2025
6102	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714396	1	2025
6103	0.000776250000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714413	1	2025
6104	0.002025300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714431	1	2025
6105	0.023629400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714448	1	2025
6106	0.023006800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714466	1	2025
6107	0.025464550000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714486	1	2025
6108	0.025173400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714503	1	2025
6109	0.026495900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714528	1	2025
6110	0.032980800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714545	1	2025
6111	0.033672500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714563	1	2025
6112	0.031265100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714581	1	2025
6113	0.027191100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714599	1	2025
6114	0.030196300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714617	1	2025
6115	0.036916100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714634	1	2025
6116	0.031226900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714652	1	2025
6117	0.049691700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714673	1	2025
6118	0.056162400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714691	1	2025
6119	0.046312600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714708	1	2025
6120	0.034028500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714725	1	2025
6121	0.041175500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714744	1	2025
6122	0.037216100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714762	1	2025
6123	0.036366800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71478	1	2025
6124	0.067006800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714798	1	2025
6125	0.078611500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714821	1	2025
6126	0.058030900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714839	1	2025
6127	0.034133900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714862	1	2025
6128	0.037469800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714892	1	2025
6129	0.036042100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714909	1	2025
6130	0.039364700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714925	1	2025
6131	0.095922600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714941	1	2025
6132	0.085513200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714958	1	2025
6133	0.066185500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.714974	1	2025
6134	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71499	1	2025
6135	0.039226300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715007	1	2025
6136	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715023	1	2025
6137	0.014059200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715039	1	2025
6138	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715055	1	2025
6139	0.015657600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71507	1	2025
6140	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715086	1	2025
6141	0.059976900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715103	1	2025
6142	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715119	1	2025
6143	0.020870500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715134	1	2025
6144	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715151	1	2025
6145	0.062865050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715168	1	2025
6146	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715184	1	2025
6147	0.033264000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.7152	1	2025
6148	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715216	1	2025
6149	0.009108000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715232	1	2025
6150	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715248	1	2025
6151	0.009952800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715264	1	2025
6152	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71528	1	2025
6153	0.011392950000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715297	1	2025
6154	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715313	1	2025
6155	0.009268650000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715329	1	2025
6156	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715345	1	2025
6157	0.040789200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715361	1	2025
6158	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715376	1	2025
6159	0.041472000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715393	1	2025
6160	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715409	1	2025
6161	0.020828400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715425	1	2025
6162	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715441	1	2025
6163	0.009249450000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715456	1	2025
6164	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715473	1	2025
6165	0.007758000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71549	1	2025
6166	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715506	1	2025
6167	0.010130400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715522	1	2025
6168	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715538	1	2025
6169	0.008080800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715554	1	2025
6170	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715571	1	2025
6171	0.035136000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715586	1	2025
6172	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715603	1	2025
6173	0.032185050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715619	1	2025
6174	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715635	1	2025
6175	0.018845150000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715652	1	2025
6176	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715671	1	2025
6177	0.004042000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715688	1	2025
6178	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715706	1	2025
6179	0.004574450000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715723	1	2025
6180	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715743	1	2025
6181	0.006644400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71576	1	2025
6182	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715778	1	2025
6183	0.006595200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715795	1	2025
6184	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715839	1	2025
6185	0.013536000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715866	1	2025
6186	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715882	1	2025
6187	0.013852800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715899	1	2025
6188	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715915	1	2025
6189	0.005623200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715931	1	2025
6190	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715947	1	2025
6191	0.001408800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715963	1	2025
6192	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715979	1	2025
6193	0.001411050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.715995	1	2025
6194	0.000646900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716012	1	2025
6195	0.016197750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716028	1	2025
6196	0.014917350000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716047	1	2025
6197	0.017051800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716063	1	2025
6198	0.016780050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716079	1	2025
6199	0.017933650000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716096	1	2025
6200	0.016838400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716118	1	2025
6201	0.018948500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716134	1	2025
6202	0.017497200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716156	1	2025
6203	0.019186850000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716173	1	2025
6204	0.018615450000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716189	1	2025
6205	0.021583500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716206	1	2025
6206	0.020227750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716223	1	2025
6207	0.021014400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716239	1	2025
6208	0.019627200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716255	1	2025
6209	0.024622600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716272	1	2025
6210	0.021848700000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716288	1	2025
6211	0.021751200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716304	1	2025
6212	0.026477100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716319	1	2025
6213	0.023304350000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716335	1	2025
6214	0.026382900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716351	1	2025
6215	0.029684600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716368	1	2025
6216	0.026291100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716385	1	2025
6217	0.024451000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716401	1	2025
6218	0.024571200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716416	1	2025
6219	0.028112800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716437	1	2025
6220	0.032024900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716456	1	2025
6221	0.032436100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716473	1	2025
6222	0.033151400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716491	1	2025
6223	0.028340100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716509	1	2025
6224	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716528	1	2025
6225	0.029851400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716546	1	2025
6226	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716564	1	2025
6227	0.006845750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716582	1	2025
6228	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.7166	1	2025
6229	0.014200200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716618	1	2025
6230	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716638	1	2025
6231	0.016530850000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716656	1	2025
6232	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716674	1	2025
6233	0.028377650000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716691	1	2025
6234	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71671	1	2025
6235	0.011171350000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716728	1	2025
6236	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716747	1	2025
6237	0.008928000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716764	1	2025
6238	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716782	1	2025
6239	0.008595600000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.7168	1	2025
6240	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716828	1	2025
6241	0.003899800000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716846	1	2025
6242	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716877	1	2025
6243	0.009733050000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716898	1	2025
6244	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716916	1	2025
6245	0.004742100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716935	1	2025
6246	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716953	1	2025
6247	0.008789850000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.716972	1	2025
6248	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71699	1	2025
6249	0.009504000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717009	1	2025
6250	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717027	1	2025
6251	0.007303200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717045	1	2025
6252	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717062	1	2025
6253	0.003485300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71708	1	2025
6254	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717098	1	2025
6255	0.005873450000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717115	1	2025
6256	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717132	1	2025
6257	0.005025000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71715	1	2025
6258	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717169	1	2025
6259	0.006370500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717186	1	2025
6260	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717204	1	2025
6261	0.007088900000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717221	1	2025
6262	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717239	1	2025
6263	0.006204000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717258	1	2025
6264	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717276	1	2025
6265	0.004320000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717294	1	2025
6266	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717312	1	2025
6267	0.003708750000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717331	1	2025
6268	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717349	1	2025
6269	0.003562150000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71738	1	2025
6270	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717397	1	2025
6271	0.003624200000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717415	1	2025
6272	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717434	1	2025
6273	0.004385100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717452	1	2025
6274	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717473	1	2025
6275	0.003834000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717491	1	2025
6276	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71751	1	2025
6277	0.001713500000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717528	1	2025
6278	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717545	1	2025
6279	0.001148400000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717563	1	2025
6280	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71758	1	2025
6281	0.000371300000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717598	1	2025
6282	0.000001900000000	USD	f	S4 LRS Disk Operations	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717616	1	2025
6283	0.000177100000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717633	1	2025
6284	0.424764000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717651	1	2025
6285	0.013752000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717669	1	2025
6286	0.013572000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717688	1	2025
6287	0.033192000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717706	1	2025
6288	0.012888000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717723	1	2025
6289	0.010224000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717741	1	2025
6290	0.011772000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717758	1	2025
6291	0.015012000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717777	1	2025
6292	0.014112000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717794	1	2025
6293	0.008892000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717817	1	2025
6294	0.012492000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717835	1	2025
6295	0.006552000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717854	1	2025
6296	0.011088000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717871	1	2025
6297	0.021204000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717889	1	2025
6298	0.012348000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717907	1	2025
6299	0.012780000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717925	1	2025
6300	0.014436000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717943	1	2025
6301	0.016308000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.71796	1	2025
6302	0.010512000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717978	1	2025
6303	0.011052000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.717997	1	2025
6304	0.012060000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718014	1	2025
6305	0.016164000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718032	1	2025
6306	0.012276000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718051	1	2025
6307	0.013644000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718069	1	2025
6308	0.015480000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718088	1	2025
6309	0.012168000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718106	1	2025
6310	0.006192000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718123	1	2025
6311	0.013176000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718141	1	2025
6312	0.010764000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718158	1	2025
6313	0.014076000000000	USD	f	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718176	1	2025
6314	0.996804000000000	USD	t	Snapshots ZRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718186	\N	2025
6315	0.271548000000000	USD	t	Snapshots LRS Snapshots	9	SNAPSHOT	Storage	2026-04-17 10:02:46.718198	\N	2025
6316	0.000021460056305	USD	t	Intra Continent Data Transfer Out	9	VM	Bandwidth	2026-04-17 10:02:46.71823	\N	2025
6317	0.000009374320507	USD	f	Intra Continent Data Transfer Out	9	VM	Bandwidth	2026-04-17 10:02:46.718241	1	2025
6318	4.268000000000000	USD	f	D2ls v5	9	VM	Virtual Machines	2026-04-17 10:02:46.718247	1	2025
6319	0.000014450903982	USD	f	Intra Continent Data Transfer Out	9	VM	Bandwidth	2026-04-17 10:02:46.718267	3	2025
6320	0.092150970000000	USD	f	D2ls v5	9	VM	Virtual Machines	2026-04-17 10:02:46.71827	3	2025
6321	0.000015358068049	USD	f	Intra Continent Data Transfer Out	9	VM	Bandwidth	2026-04-17 10:02:46.718275	4	2025
6322	0.000003078952432	USD	f	Intra Continent Data Transfer Out	9	VM	Bandwidth	2026-04-17 10:02:46.71828	5	2025
6323	1.155922325000000	USD	f	D2ls v5	9	VM	Virtual Machines	2026-04-17 10:02:46.718285	5	2025
6324	0.000018035285175	USD	f	Intra Continent Data Transfer Out	9	VM	Bandwidth	2026-04-17 10:02:46.71829	6	2025
6325	19.897970840000000	USD	f	D2ls v5	9	VM	Virtual Machines	2026-04-17 10:02:46.718294	6	2025
6326	0.000009407848120	USD	f	Intra Continent Data Transfer Out	9	VM	Bandwidth	2026-04-17 10:02:46.718299	7	2025
6327	64.527659200000000	USD	f	D2ls v5	9	VM	Virtual Machines	2026-04-17 10:02:46.718303	7	2025
6328	0.401075268817204	USD	t	Alerts Metric Monitored	9	ALERT	Azure Monitor	2026-04-17 10:02:46.718323	\N	2025
6329	0.401209677419355	USD	t	Alerts Metric Monitored	9	ALERT	Azure Monitor	2026-04-17 10:02:46.71834	\N	2025
6330	0.354704301075269	USD	t	Alerts Metric Monitored	9	ALERT	Azure Monitor	2026-04-17 10:02:46.718357	\N	2025
6331	0.394758064516130	USD	t	Alerts Metric Monitored	9	ALERT	Azure Monitor	2026-04-17 10:02:46.718373	\N	2025
6332	0.382853148225695	USD	f	Standard Traffic Analytics Processing	9	NSG	Network Watcher	2026-04-17 10:02:46.718393	4	2025
6333	0.096887263655663	USD	t	Standard Traffic Analytics Processing	9	NSG	Network Watcher	2026-04-17 10:02:46.718411	\N	2025
6334	3.600000000000000	USD	t	Standard IPv4 Static Public IP	9	PUBLIC_IP	Virtual Network	2026-04-17 10:02:46.718427	\N	2025
6335	3.600000000000000	USD	f	Standard IPv4 Static Public IP	9	PUBLIC_IP	Virtual Network	2026-04-17 10:02:46.718443	3	2025
6336	3.600000000000000	USD	f	Standard IPv4 Static Public IP	9	PUBLIC_IP	Virtual Network	2026-04-17 10:02:46.718459	4	2025
6337	3.600000000000000	USD	f	Standard IPv4 Static Public IP	9	PUBLIC_IP	Virtual Network	2026-04-17 10:02:46.718474	4	2025
6338	3.600000000000000	USD	f	Standard IPv4 Static Public IP	9	PUBLIC_IP	Virtual Network	2026-04-17 10:02:46.718489	6	2025
6339	0.526506974110000	USD	t	Analytics Logs Data Ingestion	9	LOG_ANALYTICS	Log Analytics	2026-04-17 10:02:46.718504	\N	2025
6340	1.603516449730000	USD	t	Analytics Logs Data Ingestion	9	LOG_ANALYTICS	Log Analytics	2026-04-17 10:02:46.718519	\N	2025
6341	5.557973492890000	USD	f	Analytics Logs Data Ingestion	9	LOG_ANALYTICS	Log Analytics	2026-04-17 10:02:46.718533	4	2025
6342	1.851041339290000	USD	f	Analytics Logs Data Ingestion	9	LOG_ANALYTICS	Log Analytics	2026-04-17 10:02:46.718548	6	2025
6343	0.000001460000000	USD	t	Intra Continent Data Transfer Out	9	STORAGE	Bandwidth	2026-04-17 10:02:46.718563	\N	2025
6344	0.001929840000000	USD	t	All Other Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718578	\N	2025
6345	0.004185730000000	USD	t	Cool Data Retrieval	9	STORAGE	Storage	2026-04-17 10:02:46.718592	\N	2025
6346	0.001772240000000	USD	t	Cool LRS Data Stored	9	STORAGE	Storage	2026-04-17 10:02:46.718607	\N	2025
6347	1.756460000000000	USD	t	Cool LRS Write Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718623	\N	2025
6348	0.002908000000000	USD	t	Cool Read Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718637	\N	2025
6349	0.038550600000000	USD	t	LRS List and Create Container Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718651	\N	2025
6350	0.054979560000000	USD	t	Class 2 Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718666	\N	2025
6351	0.000024840000000	USD	t	Delete Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718681	\N	2025
6352	0.000939168000000	USD	t	LRS Class 1 Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718696	\N	2025
6353	0.001684800000000	USD	t	LRS Data Stored	9	STORAGE	Storage	2026-04-17 10:02:46.71871	\N	2025
6354	0.000313920000000	USD	t	LRS List and Create Container Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718725	\N	2025
6355	0.583921332000000	USD	t	LRS Write Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718739	\N	2025
6356	0.020473800000000	USD	t	Protocol Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718754	\N	2025
6357	0.151199916000000	USD	t	Read Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718768	\N	2025
6358	0.000000720000000	USD	t	Scan Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718782	\N	2025
6359	0.000024948000000	USD	t	Write Operations	9	STORAGE	Storage	2026-04-17 10:02:46.718797	\N	2025
6360	167.000000000000000	USD	t	[RESERVATION] D2ls v5	8	RESERVATION	Virtual Machines	2026-04-17 10:03:58.261506	\N	2025
6361	47.830000000000000	USD	t	[RESERVATION] D2s v5	8	RESERVATION	Virtual Machines	2026-04-17 10:03:58.261529	\N	2025
6362	0.000081700000000	USD	t	All Other Operations	8	STORAGE	Storage	2026-04-17 10:03:58.261547	\N	2025
6363	0.299980800000000	USD	t	LRS Data Stored	8	STORAGE	Storage	2026-04-17 10:03:58.261564	\N	2025
6364	0.299683200000000	USD	t	Snapshots LRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261582	\N	2025
6365	1.968341000000000	USD	t	E10 ZRS Disk Operations	8	DISK	Storage	2026-04-17 10:03:58.261589	\N	2025
6366	3.599769600000000	USD	t	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261594	\N	2025
6367	1.204571000000000	USD	f	E10 ZRS Disk Operations	8	DISK	Storage	2026-04-17 10:03:58.261601	1	2025
6368	3.599769600000000	USD	f	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261606	1	2025
6369	3.599769600000000	USD	f	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261612	2	2025
6370	1.535901696000000	USD	f	S4 LRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261631	2	2025
6371	0.007814450000000	USD	f	S4 LRS Disk Operations	8	DISK	Storage	2026-04-17 10:03:58.261649	2	2025
6372	2.389122600000000	USD	f	E10 ZRS Disk Operations	8	DISK	Storage	2026-04-17 10:03:58.261655	3	2025
6373	3.599769600000000	USD	f	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261661	3	2025
6374	2.330227200000000	USD	f	E10 ZRS Disk Operations	8	DISK	Storage	2026-04-17 10:03:58.261666	4	2025
6375	3.599769600000000	USD	f	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261672	4	2025
6376	3.599769600000000	USD	f	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261685	4	2025
6377	0.723090800000000	USD	f	E10 ZRS Disk Operations	8	DISK	Storage	2026-04-17 10:03:58.261694	5	2025
6378	3.599769600000000	USD	f	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261702	5	2025
6379	1.416497800000000	USD	f	E10 ZRS Disk Operations	8	DISK	Storage	2026-04-17 10:03:58.261708	7	2025
6380	3.599769600000000	USD	f	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261714	7	2025
6381	2.456703000000000	USD	f	E10 ZRS Disk Operations	8	DISK	Storage	2026-04-17 10:03:58.261719	6	2025
6382	3.599769600000000	USD	f	E4 ZRS Disk	8	DISK	Storage	2026-04-17 10:03:58.261725	6	2025
6383	0.516373200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261747	1	2025
6384	0.002792800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261766	1	2025
6385	0.033562700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261783	1	2025
6386	0.034462000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261801	1	2025
6387	0.035252600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261829	1	2025
6388	0.033389200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261847	1	2025
6389	0.036397450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261864	1	2025
6390	0.034212550000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261882	1	2025
6391	0.037198500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.2619	1	2025
6392	0.037616500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261922	1	2025
6393	0.043614700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261941	1	2025
6394	0.039448700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261963	1	2025
6395	0.039189500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.261984	1	2025
6396	0.038359600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262005	1	2025
6397	0.047726500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262023	1	2025
6398	0.040296100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262041	1	2025
6399	0.039728100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262058	1	2025
6400	0.050803900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262075	1	2025
6401	0.047960800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262094	1	2025
6402	0.037157500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262112	1	2025
6403	0.036547700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26213	1	2025
6404	0.040819600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262148	1	2025
6405	0.043422000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262165	1	2025
6406	0.040647900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262183	1	2025
6407	0.052722200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262201	1	2025
6408	0.056725100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26222	1	2025
6409	0.045077750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262238	1	2025
6410	0.042856700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262256	1	2025
6411	0.046137100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262274	1	2025
6412	0.050537700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262291	1	2025
6413	0.049169350000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262311	1	2025
6414	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262344	1	2025
6415	0.068761350000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262362	1	2025
6416	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262379	1	2025
6417	0.055211500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262397	1	2025
6418	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262415	1	2025
6419	0.005776800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262433	1	2025
6420	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262452	1	2025
6421	0.004596350000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262483	1	2025
6422	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262511	1	2025
6423	0.009996150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262529	1	2025
6424	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262547	1	2025
6425	0.015668450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262566	1	2025
6426	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262584	1	2025
6427	0.009284500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262614	1	2025
6428	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262643	1	2025
6429	0.028548750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262672	1	2025
6430	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262689	1	2025
6431	0.041857350000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262707	1	2025
6432	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262726	1	2025
6433	0.007814400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262743	1	2025
6434	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262762	1	2025
6435	0.007266600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26278	1	2025
6436	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262797	1	2025
6437	0.005928000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262822	1	2025
6438	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26284	1	2025
6439	0.013778050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262861	1	2025
6440	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262879	1	2025
6441	0.007671800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262897	1	2025
6442	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262915	1	2025
6443	0.014204300000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262933	1	2025
6444	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262951	1	2025
6445	0.021716100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262969	1	2025
6446	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.262987	1	2025
6447	0.006102000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263006	1	2025
6448	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263024	1	2025
6449	0.008860750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263042	1	2025
6450	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26306	1	2025
6451	0.004633900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263091	1	2025
6452	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263108	1	2025
6453	0.006184850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263126	1	2025
6454	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263144	1	2025
6455	0.006759100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263165	1	2025
6456	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263183	1	2025
6457	0.008102100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.2632	1	2025
6458	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263218	1	2025
6459	0.012679200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263235	1	2025
6460	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263253	1	2025
6461	0.004032000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26327	1	2025
6462	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263288	1	2025
6463	0.002613550000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263305	1	2025
6464	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263323	1	2025
6465	0.001401400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26334	1	2025
6466	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263357	1	2025
6467	0.002153900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263376	1	2025
6468	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263402	1	2025
6469	0.002004500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263423	1	2025
6470	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263442	1	2025
6471	0.003223400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263459	1	2025
6472	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263476	1	2025
6473	0.002164800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263494	1	2025
6474	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263511	1	2025
6475	0.000398400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263529	1	2025
6476	0.016777200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263547	1	2025
6477	0.018917700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263564	1	2025
6478	0.019457500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263582	1	2025
6479	0.020157000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.2636	1	2025
6480	0.020225800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263617	1	2025
6481	0.020536500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263635	1	2025
6482	0.021147800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263652	1	2025
6483	0.023253600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26367	1	2025
6484	0.024201200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263687	1	2025
6485	0.024263200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263705	1	2025
6486	0.031226150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263722	1	2025
6487	0.023080600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263739	1	2025
6488	0.024352000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263756	1	2025
6489	0.024911000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263773	1	2025
6490	0.028339850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263791	1	2025
6491	0.026321700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263809	1	2025
6492	0.029497200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263834	1	2025
6493	0.029278700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263853	1	2025
6494	0.027125700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263877	1	2025
6495	0.026697900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263895	1	2025
6496	0.027893300000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263912	1	2025
6497	0.031815600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26393	1	2025
6498	0.031500200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263947	1	2025
6499	0.029560700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263965	1	2025
6500	0.032088100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.263983	1	2025
6501	0.031061500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264001	1	2025
6502	0.029070100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264019	1	2025
6503	0.031168750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264036	1	2025
6504	0.041861400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264054	1	2025
6505	0.041111600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264072	1	2025
6506	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26409	1	2025
6507	0.039218500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264108	1	2025
6508	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264125	1	2025
6509	0.018924950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264143	1	2025
6510	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26416	1	2025
6511	0.013324250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264178	1	2025
6512	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264196	1	2025
6513	0.011961600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264213	1	2025
6514	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264231	1	2025
6515	0.013942850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264248	1	2025
6516	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264266	1	2025
6517	0.014360150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264284	1	2025
6518	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264302	1	2025
6519	0.012420000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264319	1	2025
6520	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264337	1	2025
6521	0.011931250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264354	1	2025
6522	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264371	1	2025
6523	0.010708800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264389	1	2025
6524	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264406	1	2025
6525	0.011725750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264423	1	2025
6526	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264441	1	2025
6527	0.009172800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264458	1	2025
6528	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264475	1	2025
6529	0.013412000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264493	1	2025
6530	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26451	1	2025
6531	0.009737000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264528	1	2025
6532	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264546	1	2025
6533	0.008013600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264563	1	2025
6534	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264581	1	2025
6535	0.008587700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264599	1	2025
6536	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264619	1	2025
6537	0.013183250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26465	1	2025
6538	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264668	1	2025
6539	0.007377450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264686	1	2025
6540	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264706	1	2025
6541	0.006968000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264731	1	2025
6542	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26476	1	2025
6543	0.007098000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264789	1	2025
6544	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264832	1	2025
6545	0.008294400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26487	1	2025
6546	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264901	1	2025
6547	0.011233200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26493	1	2025
6548	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264961	1	2025
6549	0.007968000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.264995	1	2025
6550	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265027	1	2025
6551	0.005205600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265052	1	2025
6552	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26507	1	2025
6553	0.004603100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26509	1	2025
6554	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265107	1	2025
6555	0.002965200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265124	1	2025
6556	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265141	1	2025
6557	0.003196800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265156	1	2025
6558	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265172	1	2025
6559	0.002534700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265188	1	2025
6560	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265204	1	2025
6561	0.002529600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26522	1	2025
6562	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265235	1	2025
6563	0.002117850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265251	1	2025
6564	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265268	1	2025
6565	0.001130400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265283	1	2025
6566	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265299	1	2025
6567	0.000452400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265315	1	2025
6568	0.001374200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265331	1	2025
6569	0.034319250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265348	1	2025
6570	0.033681000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265365	1	2025
6571	0.034589700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265381	1	2025
6572	0.033377050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265397	1	2025
6573	0.036780500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265413	1	2025
6574	0.034706900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265429	1	2025
6575	0.038589000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265445	1	2025
6576	0.038781000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265462	1	2025
6577	0.038458700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265477	1	2025
6578	0.042740200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265493	1	2025
6579	0.039866400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265509	1	2025
6580	0.038313900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265525	1	2025
6581	0.038703100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265541	1	2025
6582	0.040302600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265557	1	2025
6583	0.040952200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265573	1	2025
6584	0.042647350000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26559	1	2025
6585	0.043892950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265608	1	2025
6586	0.042839950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265625	1	2025
6587	0.041437300000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265642	1	2025
6588	0.042256000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265659	1	2025
6589	0.047775500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265677	1	2025
6590	0.042711000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265694	1	2025
6591	0.045636900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265711	1	2025
6592	0.044981750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265728	1	2025
6593	0.046690950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265746	1	2025
6594	0.047855700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265763	1	2025
6595	0.043214600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265793	1	2025
6596	0.051403950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265818	1	2025
6597	0.054353500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265836	1	2025
6598	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265865	1	2025
6599	0.054316050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265882	1	2025
6600	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.2659	1	2025
6601	0.048093900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265916	1	2025
6602	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265932	1	2025
6603	0.015868800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265948	1	2025
6604	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265964	1	2025
6605	0.012550050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265981	1	2025
6606	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.265997	1	2025
6607	0.012519450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266017	1	2025
6608	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266034	1	2025
6609	0.015855350000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266053	1	2025
6610	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266069	1	2025
6611	0.013777000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266085	1	2025
6612	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266101	1	2025
6613	0.011960000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266118	1	2025
6614	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266135	1	2025
6615	0.011929150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266151	1	2025
6616	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266167	1	2025
6617	0.011146050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266183	1	2025
6618	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.2662	1	2025
6619	0.010311500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266216	1	2025
6620	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266231	1	2025
6621	0.015768000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266248	1	2025
6622	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266263	1	2025
6623	0.008456250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26628	1	2025
6624	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266296	1	2025
6625	0.008361400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266312	1	2025
6626	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266328	1	2025
6627	0.009279600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266344	1	2025
6628	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266359	1	2025
6629	0.008510750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266377	1	2025
6630	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266392	1	2025
6631	0.010260000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266408	1	2025
6632	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266424	1	2025
6633	0.007001500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26644	1	2025
6634	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266456	1	2025
6635	0.005959200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266472	1	2025
6636	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266488	1	2025
6637	0.008269650000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266503	1	2025
6638	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26652	1	2025
6639	0.010626000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266536	1	2025
6640	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266552	1	2025
6641	0.006400200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266567	1	2025
6642	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266583	1	2025
6643	0.006933600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266599	1	2025
6644	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266615	1	2025
6645	0.004147200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26663	1	2025
6646	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266646	1	2025
6647	0.003495800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266662	1	2025
6648	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266678	1	2025
6649	0.002581150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266695	1	2025
6650	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266713	1	2025
6651	0.002552550000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266731	1	2025
6652	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266749	1	2025
6653	0.002498500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266767	1	2025
6654	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266784	1	2025
6655	0.002120400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266801	1	2025
6656	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266836	1	2025
6657	0.001387200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266854	1	2025
6658	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266875	1	2025
6659	0.000533850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266892	1	2025
6660	0.001905100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26691	1	2025
6661	0.022914200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266927	1	2025
6662	0.026668200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266943	1	2025
6663	0.029852900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266959	1	2025
6664	0.026602050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.266974	1	2025
6665	0.026053850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26699	1	2025
6666	0.025974400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267006	1	2025
6667	0.027805250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267023	1	2025
6668	0.028659600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267039	1	2025
6669	0.049769600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267055	1	2025
6670	0.046251400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26707	1	2025
6671	0.039466250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267086	1	2025
6672	0.028527600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267102	1	2025
6673	0.029853000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267119	1	2025
6674	0.029717900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267135	1	2025
6675	0.030155700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26715	1	2025
6676	0.073065200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267166	1	2025
6677	0.052194000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267182	1	2025
6678	0.051075900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267198	1	2025
6679	0.031316600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267213	1	2025
6680	0.038040700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267229	1	2025
6681	0.039900500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267245	1	2025
6682	0.040078650000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267261	1	2025
6683	0.069692100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267277	1	2025
6684	0.052087200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267293	1	2025
6685	0.047239850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267308	1	2025
6686	0.033157000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267324	1	2025
6687	0.049459450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26734	1	2025
6688	0.046468150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267356	1	2025
6689	0.042824800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267372	1	2025
6690	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267388	1	2025
6691	0.077746950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267403	1	2025
6692	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267419	1	2025
6693	0.055304450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267435	1	2025
6694	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267454	1	2025
6695	0.026699750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267473	1	2025
6696	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26749	1	2025
6697	0.010718400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267507	1	2025
6698	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267525	1	2025
6699	0.011257800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267542	1	2025
6700	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267559	1	2025
6701	0.019968000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267577	1	2025
6702	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267594	1	2025
6703	0.011410950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267613	1	2025
6704	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267631	1	2025
6705	0.042578750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267648	1	2025
6706	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267665	1	2025
6707	0.028266300000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267683	1	2025
6708	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267701	1	2025
6709	0.022713700000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267719	1	2025
6710	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267736	1	2025
6711	0.008249200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267767	1	2025
6712	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267784	1	2025
6713	0.013220400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267801	1	2025
6714	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267825	1	2025
6715	0.023091250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267842	1	2025
6716	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26787	1	2025
6717	0.010882750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267887	1	2025
6718	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267905	1	2025
6719	0.033251900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267921	1	2025
6720	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267938	1	2025
6721	0.035405950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267954	1	2025
6722	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26797	1	2025
6723	0.022338000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.267986	1	2025
6724	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268003	1	2025
6725	0.008379050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268019	1	2025
6726	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268035	1	2025
6727	0.013759200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268052	1	2025
6728	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268068	1	2025
6729	0.009259200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268085	1	2025
6730	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268102	1	2025
6731	0.007458000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268117	1	2025
6732	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268134	1	2025
6733	0.021366600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268149	1	2025
6734	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268166	1	2025
6735	0.022896000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268182	1	2025
6736	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268198	1	2025
6737	0.012090300000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268214	1	2025
6738	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268229	1	2025
6739	0.002822400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268246	1	2025
6740	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268261	1	2025
6741	0.003138850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268277	1	2025
6742	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268294	1	2025
6743	0.002213400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26831	1	2025
6744	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268325	1	2025
6745	0.002222400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268341	1	2025
6746	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268357	1	2025
6747	0.007754400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268373	1	2025
6748	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26839	1	2025
6749	0.004180800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268406	1	2025
6750	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268422	1	2025
6751	0.001370800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268437	1	2025
6752	0.000620050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268453	1	2025
6753	0.015535900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268469	1	2025
6754	0.014909600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268485	1	2025
6755	0.016337450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268501	1	2025
6756	0.015444550000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268517	1	2025
6757	0.016049650000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268533	1	2025
6758	0.015077150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268548	1	2025
6759	0.018464750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268564	1	2025
6760	0.017771800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26858	1	2025
6761	0.020882900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268597	1	2025
6762	0.024685850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268613	1	2025
6763	0.019637800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268629	1	2025
6764	0.018534400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268648	1	2025
6765	0.020078550000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268665	1	2025
6766	0.021092000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268701	1	2025
6767	0.022007400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268719	1	2025
6768	0.023137350000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268736	1	2025
6769	0.025618500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268764	1	2025
6770	0.018465600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268797	1	2025
6771	0.021288400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268824	1	2025
6772	0.027300800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268854	1	2025
6773	0.025355200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268875	1	2025
6774	0.021774100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268894	1	2025
6775	0.024468850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26891	1	2025
6776	0.025534850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268926	1	2025
6777	0.020948050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268942	1	2025
6778	0.023479600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268958	1	2025
6779	0.025985650000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268975	1	2025
6780	0.024384900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.268992	1	2025
6781	0.034961100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269008	1	2025
6782	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269024	1	2025
6783	0.032914350000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269041	1	2025
6784	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269057	1	2025
6785	0.028932850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269075	1	2025
6786	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269093	1	2025
6787	0.011085250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26911	1	2025
6788	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269139	1	2025
6789	0.005133150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26917	1	2025
6790	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269198	1	2025
6791	0.010610800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269229	1	2025
6792	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269259	1	2025
6793	0.014484750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269289	1	2025
6794	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269323	1	2025
6795	0.010392650000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269354	1	2025
6796	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269385	1	2025
6797	0.008883750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269417	1	2025
6798	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269449	1	2025
6799	0.009890450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269481	1	2025
6800	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269526	1	2025
6801	0.007721200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269554	1	2025
6802	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269572	1	2025
6803	0.007519850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269598	1	2025
6804	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269626	1	2025
6805	0.008166950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269664	1	2025
6806	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269686	1	2025
6807	0.011238500000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269708	1	2025
6808	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269731	1	2025
6809	0.006508100000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269753	1	2025
6810	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269775	1	2025
6811	0.007549850000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269797	1	2025
6812	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269828	1	2025
6813	0.005113050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269862	1	2025
6814	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269888	1	2025
6815	0.009351950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.26991	1	2025
6816	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269933	1	2025
6817	0.005694450000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269955	1	2025
6818	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269977	1	2025
6819	0.004867150000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.269999	1	2025
6820	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.27002	1	2025
6821	0.007863800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270042	1	2025
6822	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270065	1	2025
6823	0.004681400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270087	1	2025
6824	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270109	1	2025
6825	0.005485050000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270131	1	2025
6826	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270152	1	2025
6827	0.005794250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270174	1	2025
6828	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270196	1	2025
6829	0.003905950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270218	1	2025
6830	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270243	1	2025
6831	0.002705400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270265	1	2025
6832	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270287	1	2025
6833	0.002237950000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270314	1	2025
6834	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270336	1	2025
6835	0.002510900000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270358	1	2025
6836	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.27038	1	2025
6837	0.002503250000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270402	1	2025
6838	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270424	1	2025
6839	0.001860200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270446	1	2025
6840	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270477	1	2025
6841	0.001233750000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270503	1	2025
6842	0.000001900000000	USD	f	S4 LRS Disk Operations	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270525	1	2025
6843	0.000423200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270546	1	2025
6844	0.424749600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270569	1	2025
6845	0.013764000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.27059	1	2025
6846	0.013578000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270612	1	2025
6847	0.033219600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270634	1	2025
6848	0.012908400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270656	1	2025
6849	0.010192800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270678	1	2025
6850	0.011792400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.2707	1	2025
6851	0.015028800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270721	1	2025
6852	0.014136000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270743	1	2025
6853	0.008890800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270765	1	2025
6854	0.012462000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270787	1	2025
6855	0.006547200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270817	1	2025
6856	0.011085600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.27084	1	2025
6857	0.021204000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270861	1	2025
6858	0.012350400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270884	1	2025
6859	0.012759600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270906	1	2025
6860	0.014433600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270928	1	2025
6861	0.016293600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270949	1	2025
6862	0.010527600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270971	1	2025
6863	0.011048400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.270993	1	2025
6864	0.012090000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271023	1	2025
6865	0.016144800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271044	1	2025
6866	0.012276000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271066	1	2025
6867	0.013652400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271087	1	2025
6868	0.015475200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271109	1	2025
6869	0.012164400000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.27113	1	2025
6870	0.006175200000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271152	1	2025
6871	0.013168800000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271174	1	2025
6872	0.010788000000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271196	1	2025
6873	0.014061600000000	USD	f	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271218	1	2025
6874	0.996811200000000	USD	t	Snapshots ZRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271231	\N	2025
6875	0.271522800000000	USD	t	Snapshots LRS Snapshots	8	SNAPSHOT	Storage	2026-04-17 10:03:58.271246	\N	2025
6876	0.000053377561271	USD	t	Intra Continent Data Transfer Out	8	VM	Bandwidth	2026-04-17 10:03:58.271272	\N	2025
6877	0.097000000000000	USD	t	D2ls v5	8	VM	Virtual Machines	2026-04-17 10:03:58.271277	\N	2025
6878	0.000009525194764	USD	f	Intra Continent Data Transfer Out	8	VM	Bandwidth	2026-04-17 10:03:58.271284	1	2025
6879	1.261001940000000	USD	f	D2ls v5	8	VM	Virtual Machines	2026-04-17 10:03:58.271291	1	2025
6880	0.000012438558042	USD	f	Intra Continent Data Transfer Out	8	VM	Bandwidth	2026-04-17 10:03:58.271298	3	2025
6881	0.000012604855001	USD	f	Intra Continent Data Transfer Out	8	VM	Bandwidth	2026-04-17 10:03:58.271306	4	2025
6882	0.000003064423800	USD	f	Intra Continent Data Transfer Out	8	VM	Bandwidth	2026-04-17 10:03:58.271313	5	2025
6883	1.117117669000000	USD	f	D2ls v5	8	VM	Virtual Machines	2026-04-17 10:03:58.271333	5	2025
6884	0.000012174397707	USD	f	Intra Continent Data Transfer Out	8	VM	Bandwidth	2026-04-17 10:03:58.271344	6	2025
6885	0.826117960000000	USD	f	D2ls v5	8	VM	Virtual Machines	2026-04-17 10:03:58.271361	6	2025
6886	0.000009807944298	USD	f	Intra Continent Data Transfer Out	8	VM	Bandwidth	2026-04-17 10:03:58.271371	7	2025
6887	24.833654820000000	USD	f	D2ls v5	8	VM	Virtual Machines	2026-04-17 10:03:58.271378	7	2025
6888	0.420026881720430	USD	t	Alerts Metric Monitored	8	ALERT	Azure Monitor	2026-04-17 10:03:58.271416	\N	2025
6889	0.421236559139785	USD	t	Alerts Metric Monitored	8	ALERT	Azure Monitor	2026-04-17 10:03:58.27145	\N	2025
6890	0.370430107526882	USD	t	Alerts Metric Monitored	8	ALERT	Azure Monitor	2026-04-17 10:03:58.271486	\N	2025
6891	0.419892473118280	USD	t	Alerts Metric Monitored	8	ALERT	Azure Monitor	2026-04-17 10:03:58.271525	\N	2025
6892	0.289116999600083	USD	f	Standard Traffic Analytics Processing	8	NSG	Network Watcher	2026-04-17 10:03:58.271563	4	2025
6893	0.089558717049658	USD	t	Standard Traffic Analytics Processing	8	NSG	Network Watcher	2026-04-17 10:03:58.271603	\N	2025
6894	3.720000000000000	USD	t	Standard IPv4 Static Public IP	8	PUBLIC_IP	Virtual Network	2026-04-17 10:03:58.271639	\N	2025
6895	3.720000000000000	USD	f	Standard IPv4 Static Public IP	8	PUBLIC_IP	Virtual Network	2026-04-17 10:03:58.271676	3	2025
6896	3.720000000000000	USD	f	Standard IPv4 Static Public IP	8	PUBLIC_IP	Virtual Network	2026-04-17 10:03:58.271711	4	2025
6897	3.720000000000000	USD	f	Standard IPv4 Static Public IP	8	PUBLIC_IP	Virtual Network	2026-04-17 10:03:58.271745	4	2025
6898	3.720000000000000	USD	f	Standard IPv4 Static Public IP	8	PUBLIC_IP	Virtual Network	2026-04-17 10:03:58.271776	6	2025
6899	0.668127965310000	USD	t	Analytics Logs Data Ingestion	8	LOG_ANALYTICS	Log Analytics	2026-04-17 10:03:58.271824	\N	2025
6900	1.722606612870000	USD	t	Analytics Logs Data Ingestion	8	LOG_ANALYTICS	Log Analytics	2026-04-17 10:03:58.271851	\N	2025
6901	5.976788943320000	USD	f	Analytics Logs Data Ingestion	8	LOG_ANALYTICS	Log Analytics	2026-04-17 10:03:58.271878	4	2025
6902	1.983596689360000	USD	f	Analytics Logs Data Ingestion	8	LOG_ANALYTICS	Log Analytics	2026-04-17 10:03:58.2719	6	2025
6903	0.000003120000000	USD	t	Intra Continent Data Transfer Out	8	STORAGE	Bandwidth	2026-04-17 10:03:58.271916	\N	2025
6904	0.002013690000000	USD	t	All Other Operations	8	STORAGE	Storage	2026-04-17 10:03:58.271933	\N	2025
6905	0.003307210000000	USD	t	Cool Data Retrieval	8	STORAGE	Storage	2026-04-17 10:03:58.271947	\N	2025
6906	0.001694370000000	USD	t	Cool LRS Data Stored	8	STORAGE	Storage	2026-04-17 10:03:58.271961	\N	2025
6907	1.815140000000000	USD	t	Cool LRS Write Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272	\N	2025
6908	0.003007000000000	USD	t	Cool Read Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272021	\N	2025
6909	0.044172000000000	USD	t	LRS List and Create Container Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272035	\N	2025
6910	0.056869344000000	USD	t	Class 2 Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272051	\N	2025
6911	0.000025272000000	USD	t	Delete Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272065	\N	2025
6912	0.000970488000000	USD	t	LRS Class 1 Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272078	\N	2025
6913	0.001673160000000	USD	t	LRS Data Stored	8	STORAGE	Storage	2026-04-17 10:03:58.272091	\N	2025
6914	0.000324360000000	USD	t	LRS List and Create Container Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272104	\N	2025
6915	0.600225240000000	USD	t	LRS Write Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272118	\N	2025
6916	0.021018900000000	USD	t	Protocol Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272133	\N	2025
6917	0.154491306000000	USD	t	Read Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272145	\N	2025
6918	0.000000720000000	USD	t	Scan Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272159	\N	2025
6919	0.000025416000000	USD	t	Write Operations	8	STORAGE	Storage	2026-04-17 10:03:58.272172	\N	2025
6920	41.750000000000000	USD	t	[RESERVATION] D2ls v5	7	RESERVATION	Virtual Machines	2026-04-17 10:26:38.384657	\N	2025
6921	167.000000000000000	USD	t	[RESERVATION] D2ls v5	7	RESERVATION	Virtual Machines	2026-04-17 10:26:38.38475	\N	2025
6922	47.830000000000000	USD	t	[RESERVATION] D2s v5	7	RESERVATION	Virtual Machines	2026-04-17 10:26:38.384801	\N	2025
6923	0.000085140000000	USD	t	All Other Operations	7	STORAGE	Storage	2026-04-17 10:26:38.384876	\N	2025
6924	0.299980800000000	USD	t	LRS Data Stored	7	STORAGE	Storage	2026-04-17 10:26:38.384965	\N	2025
6925	0.299683200000000	USD	t	Snapshots LRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.385092	\N	2025
6926	1.954489600000000	USD	t	E10 ZRS Disk Operations	7	DISK	Storage	2026-04-17 10:26:38.385131	\N	2025
6927	3.599769600000000	USD	t	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385165	\N	2025
6928	1.169148000000000	USD	f	E10 ZRS Disk Operations	7	DISK	Storage	2026-04-17 10:26:38.3852	1	2025
6929	3.599769600000000	USD	f	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385232	1	2025
6930	3.599769600000000	USD	f	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385264	2	2025
6931	1.535901696000000	USD	f	S4 LRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385356	2	2025
6932	0.007785000000000	USD	f	S4 LRS Disk Operations	7	DISK	Storage	2026-04-17 10:26:38.385437	2	2025
6933	2.316751400000000	USD	f	E10 ZRS Disk Operations	7	DISK	Storage	2026-04-17 10:26:38.385479	3	2025
6934	3.599769600000000	USD	f	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385516	3	2025
6935	2.286987600000000	USD	f	E10 ZRS Disk Operations	7	DISK	Storage	2026-04-17 10:26:38.385553	4	2025
6936	3.599769600000000	USD	f	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385588	4	2025
6937	3.599769600000000	USD	f	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385629	4	2025
6938	0.790771800000000	USD	f	E10 ZRS Disk Operations	7	DISK	Storage	2026-04-17 10:26:38.385685	5	2025
6939	3.599769600000000	USD	f	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385738	5	2025
6940	1.171925200000000	USD	f	E10 ZRS Disk Operations	7	DISK	Storage	2026-04-17 10:26:38.385777	7	2025
6941	3.599769600000000	USD	f	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385806	7	2025
6942	2.572371400000000	USD	f	E10 ZRS Disk Operations	7	DISK	Storage	2026-04-17 10:26:38.385836	6	2025
6943	3.599769600000000	USD	f	E4 ZRS Disk	7	DISK	Storage	2026-04-17 10:26:38.385861	6	2025
6944	0.516373200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.385944	1	2025
6945	0.001373250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.38602	1	2025
6946	0.032966650000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386104	1	2025
6947	0.033124150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386169	1	2025
6948	0.035312050000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386253	1	2025
6949	0.033550000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386311	1	2025
6950	0.034011500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386371	1	2025
6951	0.033819600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386424	1	2025
6952	0.035415000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386483	1	2025
6953	0.032822000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386537	1	2025
6954	0.035739150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386597	1	2025
6955	0.033084100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386658	1	2025
6956	0.036758700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386725	1	2025
6957	0.039400200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386788	1	2025
6958	0.044352000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386857	1	2025
6959	0.039834250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386917	1	2025
6960	0.039485600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.386978	1	2025
6961	0.059764450000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387041	1	2025
6962	0.042166750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387122	1	2025
6963	0.042892600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387184	1	2025
6964	0.051843300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387247	1	2025
6965	0.054655400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387308	1	2025
6966	0.039651100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387377	1	2025
6967	0.056147350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.38744	1	2025
6968	0.038068400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387516	1	2025
6969	0.046124000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387577	1	2025
6970	0.052980000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387644	1	2025
6971	0.050511100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387705	1	2025
6972	0.106972750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387766	1	2025
6973	0.045179200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387853	1	2025
6974	0.042142200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.387912	1	2025
6975	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.38798	1	2025
6976	0.045409600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388038	1	2025
6977	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388096	1	2025
6978	0.046600300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388154	1	2025
6979	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388214	1	2025
6980	0.015394250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388272	1	2025
6981	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.38833	1	2025
6982	0.028316200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388389	1	2025
6983	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388449	1	2025
6984	0.024170400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388508	1	2025
6985	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388565	1	2025
6986	0.010186050000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388623	1	2025
6987	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388686	1	2025
6988	0.008760000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388739	1	2025
6989	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388797	1	2025
6990	0.009545000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.38886	1	2025
6991	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388917	1	2025
6992	0.009119050000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.388989	1	2025
6993	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389043	1	2025
6994	0.012990550000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389095	1	2025
6995	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389146	1	2025
6996	0.025813550000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389202	1	2025
6997	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389266	1	2025
6998	0.015735150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389324	1	2025
6999	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389364	1	2025
7000	0.007752000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389405	1	2025
7001	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389437	1	2025
7002	0.007585600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389468	1	2025
7003	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.38952	1	2025
7004	0.018823750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389552	1	2025
7005	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.3896	1	2025
7006	0.008083200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389633	1	2025
7007	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389665	1	2025
7008	0.006408150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389695	1	2025
7009	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389726	1	2025
7010	0.015795250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389756	1	2025
7011	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389786	1	2025
7012	0.011444800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389823	1	2025
7013	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389853	1	2025
7014	0.002520000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389882	1	2025
7015	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389925	1	2025
7016	0.001808400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389956	1	2025
7017	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.389986	1	2025
7018	0.003776200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390014	1	2025
7019	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390044	1	2025
7020	0.004406400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390074	1	2025
7021	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390104	1	2025
7022	0.003189700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390132	1	2025
7023	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390162	1	2025
7024	0.005519350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39019	1	2025
7025	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39022	1	2025
7026	0.006307200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390249	1	2025
7027	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390294	1	2025
7028	0.002040000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390323	1	2025
7029	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390354	1	2025
7030	0.001420250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390385	1	2025
7031	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39043	1	2025
7032	0.001576800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390461	1	2025
7033	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390495	1	2025
7034	0.001106850000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39053	1	2025
7035	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39056	1	2025
7036	0.000570400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390592	1	2025
7037	0.016601200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390625	1	2025
7038	0.018563600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390654	1	2025
7039	0.019077800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390682	1	2025
7040	0.020138600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390713	1	2025
7041	0.020374500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390755	1	2025
7042	0.020859900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390784	1	2025
7043	0.020998000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390821	1	2025
7044	0.019895000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390851	1	2025
7045	0.021846500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390882	1	2025
7046	0.022420500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390911	1	2025
7047	0.023401700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.390941	1	2025
7048	0.024990700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391029	1	2025
7049	0.025774950000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391059	1	2025
7050	0.025495200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391088	1	2025
7051	0.030163000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391134	1	2025
7052	0.024320600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391176	1	2025
7053	0.027750300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391222	1	2025
7054	0.027714000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391265	1	2025
7055	0.029269900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391309	1	2025
7056	0.030010700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391351	1	2025
7057	0.042828700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391394	1	2025
7058	0.033297400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391437	1	2025
7059	0.028349800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391482	1	2025
7060	0.029779200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391527	1	2025
7061	0.032879600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39157	1	2025
7062	0.034989150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391614	1	2025
7063	0.035584200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391655	1	2025
7064	0.035734700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391699	1	2025
7065	0.031789600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39175	1	2025
7066	0.031155700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391795	1	2025
7067	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391857	1	2025
7068	0.033221850000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39191	1	2025
7069	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.391965	1	2025
7070	0.021350250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392014	1	2025
7071	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392074	1	2025
7072	0.018478800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392127	1	2025
7073	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39217	1	2025
7074	0.017479550000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392213	1	2025
7075	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392258	1	2025
7076	0.017274900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392303	1	2025
7077	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392359	1	2025
7078	0.012771500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392403	1	2025
7079	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392453	1	2025
7080	0.011250000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.3925	1	2025
7081	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39255	1	2025
7082	0.011344400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392601	1	2025
7083	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392651	1	2025
7084	0.016228800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392712	1	2025
7085	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392759	1	2025
7086	0.016579200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392807	1	2025
7087	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392861	1	2025
7088	0.014108250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392914	1	2025
7089	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.392961	1	2025
7090	0.024427200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393008	1	2025
7091	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393055	1	2025
7092	0.009714250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393102	1	2025
7093	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393148	1	2025
7094	0.008048400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393201	1	2025
7095	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39325	1	2025
7096	0.007671950000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393304	1	2025
7097	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393354	1	2025
7098	0.012172800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393401	1	2025
7099	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393448	1	2025
7100	0.008046000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393503	1	2025
7101	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393551	1	2025
7102	0.009853950000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393599	1	2025
7103	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393646	1	2025
7104	0.008439600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393692	1	2025
7105	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393746	1	2025
7106	0.005918400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393792	1	2025
7107	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393842	1	2025
7108	0.004870250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393889	1	2025
7109	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.393935	1	2025
7110	0.004815850000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39398	1	2025
7111	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39403	1	2025
7112	0.005832000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394075	1	2025
7113	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394125	1	2025
7114	0.004794100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394173	1	2025
7115	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394219	1	2025
7116	0.003415150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394267	1	2025
7117	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394314	1	2025
7118	0.003444700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394358	1	2025
7119	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394404	1	2025
7120	0.002528750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394445	1	2025
7121	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394488	1	2025
7122	0.001648250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394535	1	2025
7123	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394578	1	2025
7124	0.001331250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394621	1	2025
7125	0.000001800000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394666	1	2025
7126	0.001692000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394705	1	2025
7127	0.000002000000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394745	1	2025
7128	0.000749800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394784	1	2025
7129	0.001363650000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39484	1	2025
7130	0.033319500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394881	1	2025
7131	0.033925350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.394944	1	2025
7132	0.035001300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395001	1	2025
7133	0.035526800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395035	1	2025
7134	0.036270700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395063	1	2025
7135	0.036733900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395087	1	2025
7136	0.037982800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395113	1	2025
7137	0.037472750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395149	1	2025
7138	0.039281000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395178	1	2025
7139	0.039227550000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395204	1	2025
7140	0.042948450000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395228	1	2025
7141	0.040510750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395253	1	2025
7142	0.043110250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395279	1	2025
7143	0.044057050000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395302	1	2025
7144	0.042218350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395331	1	2025
7145	0.040276500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395355	1	2025
7146	0.044856500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395387	1	2025
7147	0.042608050000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395411	1	2025
7148	0.048082350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395435	1	2025
7149	0.062113650000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395459	1	2025
7150	0.045418500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395481	1	2025
7151	0.046334600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395504	1	2025
7152	0.047048700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395528	1	2025
7153	0.051156650000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395551	1	2025
7154	0.050076300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39577	1	2025
7155	0.051660100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395835	1	2025
7156	0.052568400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395887	1	2025
7157	0.051385000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395912	1	2025
7158	0.048555400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395935	1	2025
7159	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395971	1	2025
7160	0.052320350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.395993	1	2025
7161	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396016	1	2025
7162	0.053231500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396039	1	2025
7163	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396063	1	2025
7164	0.022968000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396087	1	2025
7165	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396116	1	2025
7166	0.019123500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396144	1	2025
7167	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396166	1	2025
7168	0.021286800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396187	1	2025
7169	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396208	1	2025
7170	0.015263500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396231	1	2025
7171	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396257	1	2025
7172	0.015150000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396279	1	2025
7173	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396335	1	2025
7174	0.014650500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396359	1	2025
7175	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396384	1	2025
7176	0.016089200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396407	1	2025
7177	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396428	1	2025
7178	0.017865300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39645	1	2025
7179	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396471	1	2025
7180	0.014159450000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396493	1	2025
7181	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396513	1	2025
7182	0.024357150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396535	1	2025
7183	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396556	1	2025
7184	0.010442400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396578	1	2025
7185	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39661	1	2025
7186	0.008618400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396632	1	2025
7187	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396653	1	2025
7188	0.007966700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396674	1	2025
7189	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396696	1	2025
7190	0.008870400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396719	1	2025
7191	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39674	1	2025
7192	0.008387850000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396761	1	2025
7193	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396783	1	2025
7194	0.010169300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396805	1	2025
7195	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396833	1	2025
7196	0.008780300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396854	1	2025
7197	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396875	1	2025
7198	0.005897850000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396896	1	2025
7199	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396918	1	2025
7200	0.005082000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396939	1	2025
7201	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.396964	1	2025
7202	0.004782050000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397033	1	2025
7203	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397058	1	2025
7204	0.006598800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397092	1	2025
7205	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397114	1	2025
7206	0.004154250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397134	1	2025
7207	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397154	1	2025
7208	0.003523700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397175	1	2025
7209	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397195	1	2025
7210	0.003441600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397215	1	2025
7211	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397234	1	2025
7212	0.002510900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397253	1	2025
7213	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397273	1	2025
7214	0.001905600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397293	1	2025
7215	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397313	1	2025
7216	0.001634050000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397332	1	2025
7217	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397351	1	2025
7218	0.001224350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397371	1	2025
7219	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39739	1	2025
7220	0.000784250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39741	1	2025
7221	0.000957800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397429	1	2025
7222	0.023052650000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397449	1	2025
7223	0.022780900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397468	1	2025
7224	0.025453750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397488	1	2025
7225	0.030845200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397508	1	2025
7226	0.026359150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397532	1	2025
7227	0.026038700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397552	1	2025
7228	0.025222500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397571	1	2025
7229	0.023496400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39759	1	2025
7230	0.025776400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39761	1	2025
7231	0.025522950000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397629	1	2025
7232	0.029850700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397648	1	2025
7233	0.052600450000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397667	1	2025
7234	0.061622750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397687	1	2025
7235	0.053242650000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397706	1	2025
7236	0.030119750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397726	1	2025
7237	0.042097150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397745	1	2025
7238	0.037626000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397764	1	2025
7239	0.040163800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397784	1	2025
7240	0.063648900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397803	1	2025
7241	0.093514600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397828	1	2025
7242	0.059283300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397847	1	2025
7243	0.036498700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397866	1	2025
7244	0.034777150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397886	1	2025
7245	0.038940000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397904	1	2025
7246	0.057879200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397924	1	2025
7247	0.046053900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397943	1	2025
7248	0.088528000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397962	1	2025
7249	0.057780000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.397981	1	2025
7250	0.032912000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398	1	2025
7251	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39802	1	2025
7252	0.040200300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39804	1	2025
7253	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398059	1	2025
7254	0.036451700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398078	1	2025
7255	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398097	1	2025
7256	0.016773600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398116	1	2025
7257	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398135	1	2025
7258	0.064713600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398154	1	2025
7259	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398173	1	2025
7260	0.063050150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398192	1	2025
7261	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398212	1	2025
7262	0.035147450000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398231	1	2025
7263	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398251	1	2025
7264	0.010212950000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398273	1	2025
7265	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.3983	1	2025
7266	0.016790400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39832	1	2025
7267	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398339	1	2025
7268	0.012806400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398358	1	2025
7269	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398378	1	2025
7270	0.015810000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398397	1	2025
7271	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398415	1	2025
7272	0.063883100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398434	1	2025
7273	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398453	1	2025
7274	0.047804200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398472	1	2025
7275	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39849	1	2025
7276	0.027868750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398509	1	2025
7277	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398528	1	2025
7278	0.007776000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398547	1	2025
7279	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398566	1	2025
7280	0.008690400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398585	1	2025
7281	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398603	1	2025
7282	0.007353600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398622	1	2025
7283	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398641	1	2025
7284	0.006858000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398659	1	2025
7285	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398678	1	2025
7286	0.044272300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398697	1	2025
7287	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398717	1	2025
7288	0.021153600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398735	1	2025
7289	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398754	1	2025
7290	0.019042900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398773	1	2025
7291	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398792	1	2025
7292	0.004427800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398815	1	2025
7293	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398835	1	2025
7294	0.007284000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398853	1	2025
7295	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398872	1	2025
7296	0.007019750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398892	1	2025
7297	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398911	1	2025
7298	0.006360300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39893	1	2025
7299	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398958	1	2025
7300	0.013833100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.398987	1	2025
7301	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399015	1	2025
7302	0.007176000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399044	1	2025
7303	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399089	1	2025
7304	0.004866000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399124	1	2025
7305	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399154	1	2025
7306	0.001603200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399187	1	2025
7307	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39922	1	2025
7308	0.003187900000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399252	1	2025
7309	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399286	1	2025
7310	0.001705550000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399325	1	2025
7311	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399371	1	2025
7312	0.000760800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399402	1	2025
7313	0.000609550000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399439	1	2025
7314	0.014636550000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399476	1	2025
7315	0.015061150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399509	1	2025
7316	0.015779250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399555	1	2025
7317	0.016335850000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399586	1	2025
7318	0.016285150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399618	1	2025
7319	0.016879600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39965	1	2025
7320	0.016969500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399677	1	2025
7321	0.017316150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399709	1	2025
7322	0.018113350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399743	1	2025
7323	0.017991350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399776	1	2025
7324	0.020779800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39982	1	2025
7325	0.019010950000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39986	1	2025
7326	0.022134400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399891	1	2025
7327	0.021383500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399921	1	2025
7328	0.020355150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.39995	1	2025
7329	0.022810250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.399984	1	2025
7330	0.018075250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400018	1	2025
7331	0.022030700000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400059	1	2025
7332	0.025244550000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400088	1	2025
7333	0.026602200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400119	1	2025
7334	0.036311000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400147	1	2025
7335	0.019387000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400177	1	2025
7336	0.023078450000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400209	1	2025
7337	0.021713850000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400238	1	2025
7338	0.023847800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400274	1	2025
7339	0.026870250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400309	1	2025
7340	0.028999100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.40036	1	2025
7341	0.026272100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400398	1	2025
7342	0.023878650000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400437	1	2025
7343	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400481	1	2025
7344	0.029002400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400519	1	2025
7345	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400563	1	2025
7346	0.026484300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400604	1	2025
7347	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400823	1	2025
7348	0.014525500000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400869	1	2025
7349	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400912	1	2025
7350	0.016171100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400952	1	2025
7351	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.400992	1	2025
7352	0.010546100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401032	1	2025
7353	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401074	1	2025
7354	0.009749950000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401115	1	2025
7355	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401159	1	2025
7356	0.004312800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401199	1	2025
7357	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401241	1	2025
7358	0.004398750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401281	1	2025
7359	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401322	1	2025
7360	0.013027250000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401363	1	2025
7361	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401401	1	2025
7362	0.009380600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401443	1	2025
7363	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401483	1	2025
7364	0.013983400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401524	1	2025
7365	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401565	1	2025
7366	0.021531050000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401607	1	2025
7367	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401647	1	2025
7368	0.007757750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401689	1	2025
7369	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401734	1	2025
7370	0.006896000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401772	1	2025
7371	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401808	1	2025
7372	0.006402150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401848	1	2025
7373	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401883	1	2025
7374	0.007506800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401919	1	2025
7375	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.401955	1	2025
7376	0.007431300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.40199	1	2025
7377	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402026	1	2025
7378	0.008190750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.40206	1	2025
7379	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402097	1	2025
7380	0.008117100000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402132	1	2025
7381	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402168	1	2025
7382	0.002583000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402204	1	2025
7383	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402238	1	2025
7384	0.003825200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402274	1	2025
7385	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402308	1	2025
7386	0.006405200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402341	1	2025
7387	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402375	1	2025
7388	0.004687000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402407	1	2025
7389	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402441	1	2025
7390	0.002836350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402473	1	2025
7391	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402508	1	2025
7392	0.002822300000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402541	1	2025
7393	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402574	1	2025
7394	0.002900600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402607	1	2025
7395	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402639	1	2025
7396	0.001148350000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402673	1	2025
7397	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402702	1	2025
7398	0.001448750000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402732	1	2025
7399	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402763	1	2025
7400	0.001253150000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402793	1	2025
7401	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402828	1	2025
7402	0.000650950000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402856	1	2025
7403	0.000001900000000	USD	f	S4 LRS Disk Operations	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402886	1	2025
7404	0.000702650000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402916	1	2025
7405	0.424749600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402945	1	2025
7406	0.013764000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402977	1	2025
7407	0.013578000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.402995	1	2025
7408	0.033219600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403014	1	2025
7409	0.012908400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403032	1	2025
7410	0.010192800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403049	1	2025
7411	0.011792400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403067	1	2025
7412	0.015028800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403084	1	2025
7413	0.014136000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403102	1	2025
7414	0.008890800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.40312	1	2025
7415	0.012462000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403137	1	2025
7416	0.006547200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403154	1	2025
7417	0.011085600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403172	1	2025
7418	0.021204000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.40319	1	2025
7419	0.012350400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403208	1	2025
7420	0.012759600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403225	1	2025
7421	0.014433600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403243	1	2025
7422	0.016293600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.40326	1	2025
7423	0.010527600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403278	1	2025
7424	0.011048400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403296	1	2025
7425	0.012090000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403314	1	2025
7426	0.016144800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403332	1	2025
7427	0.012276000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403354	1	2025
7428	0.013652400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403372	1	2025
7429	0.015475200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403391	1	2025
7430	0.012164400000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403408	1	2025
7431	0.006175200000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403426	1	2025
7432	0.013168800000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403444	1	2025
7433	0.010788000000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403462	1	2025
7434	0.014061600000000	USD	f	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.40348	1	2025
7435	0.996811200000000	USD	t	Snapshots ZRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403511	\N	2025
7436	0.271522800000000	USD	t	Snapshots LRS Snapshots	7	SNAPSHOT	Storage	2026-04-17 10:26:38.403543	\N	2025
7437	0.000108047686517	USD	t	Intra Continent Data Transfer Out	7	VM	Bandwidth	2026-04-17 10:26:38.403609	\N	2025
7438	0.000009297206998	USD	f	Intra Continent Data Transfer Out	7	VM	Bandwidth	2026-04-17 10:26:38.403615	1	2025
7439	0.776001940000000	USD	f	D2ls v5	7	VM	Virtual Machines	2026-04-17 10:26:38.403619	1	2025
7440	0.000011095330119	USD	f	Intra Continent Data Transfer Out	7	VM	Bandwidth	2026-04-17 10:26:38.403623	3	2025
7441	0.000013143252581	USD	f	Intra Continent Data Transfer Out	7	VM	Bandwidth	2026-04-17 10:26:38.403628	4	2025
7442	0.000004026778042	USD	f	Intra Continent Data Transfer Out	7	VM	Bandwidth	2026-04-17 10:26:38.403635	5	2025
7443	0.194000000000000	USD	f	D2ls v5	7	VM	Virtual Machines	2026-04-17 10:26:38.403639	5	2025
7444	0.000012273192406	USD	f	Intra Continent Data Transfer Out	7	VM	Bandwidth	2026-04-17 10:26:38.403645	6	2025
7445	1.115501940000000	USD	f	D2ls v5	7	VM	Virtual Machines	2026-04-17 10:26:38.403653	6	2025
7446	0.000010052695870	USD	f	Intra Continent Data Transfer Out	7	VM	Bandwidth	2026-04-17 10:26:38.403658	7	2025
7447	23.546787830000000	USD	f	D2ls v5	7	VM	Virtual Machines	2026-04-17 10:26:38.403665	7	2025
7448	0.424731182795699	USD	t	Alerts Metric Monitored	7	ALERT	Azure Monitor	2026-04-17 10:26:38.403743	\N	2025
7449	0.424596774193549	USD	t	Alerts Metric Monitored	7	ALERT	Azure Monitor	2026-04-17 10:26:38.403761	\N	2025
7450	0.375000000000000	USD	t	Alerts Metric Monitored	7	ALERT	Azure Monitor	2026-04-17 10:26:38.403776	\N	2025
7451	0.424865591397849	USD	t	Alerts Metric Monitored	7	ALERT	Azure Monitor	2026-04-17 10:26:38.403791	\N	2025
7452	0.290062370523810	USD	f	Standard Traffic Analytics Processing	7	NSG	Network Watcher	2026-04-17 10:26:38.403832	4	2025
7453	0.094035758171231	USD	t	Standard Traffic Analytics Processing	7	NSG	Network Watcher	2026-04-17 10:26:38.403851	\N	2025
7454	3.720000000000000	USD	t	Standard IPv4 Static Public IP	7	PUBLIC_IP	Virtual Network	2026-04-17 10:26:38.403867	\N	2025
7455	3.720000000000000	USD	f	Standard IPv4 Static Public IP	7	PUBLIC_IP	Virtual Network	2026-04-17 10:26:38.403887	3	2025
7456	3.720000000000000	USD	f	Standard IPv4 Static Public IP	7	PUBLIC_IP	Virtual Network	2026-04-17 10:26:38.403902	4	2025
7457	3.720000000000000	USD	f	Standard IPv4 Static Public IP	7	PUBLIC_IP	Virtual Network	2026-04-17 10:26:38.403917	4	2025
7458	3.720000000000000	USD	f	Standard IPv4 Static Public IP	7	PUBLIC_IP	Virtual Network	2026-04-17 10:26:38.403934	6	2025
7459	0.618583342390000	USD	t	Analytics Logs Data Ingestion	7	LOG_ANALYTICS	Log Analytics	2026-04-17 10:26:38.403955	\N	2025
7460	1.761198148190000	USD	t	Analytics Logs Data Ingestion	7	LOG_ANALYTICS	Log Analytics	2026-04-17 10:26:38.403975	\N	2025
7461	6.114420266890000	USD	f	Analytics Logs Data Ingestion	7	LOG_ANALYTICS	Log Analytics	2026-04-17 10:26:38.403989	4	2025
7462	2.050342677630000	USD	f	Analytics Logs Data Ingestion	7	LOG_ANALYTICS	Log Analytics	2026-04-17 10:26:38.404004	6	2025
7463	0.000002180000000	USD	t	Intra Continent Data Transfer Out	7	STORAGE	Bandwidth	2026-04-17 10:26:38.40402	\N	2025
7464	0.002449710000000	USD	t	All Other Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404034	\N	2025
7465	0.004453320000000	USD	t	Cool Data Retrieval	7	STORAGE	Storage	2026-04-17 10:26:38.404048	\N	2025
7466	0.001719350000000	USD	t	Cool LRS Data Stored	7	STORAGE	Storage	2026-04-17 10:26:38.404063	\N	2025
7467	1.896550000000000	USD	t	Cool LRS Write Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404078	\N	2025
7468	0.004997000000000	USD	t	Cool Read Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404092	\N	2025
7469	0.044447400000000	USD	t	LRS List and Create Container Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404105	\N	2025
7470	0.056915460000000	USD	t	Class 2 Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404121	\N	2025
7471	0.000025560000000	USD	t	Delete Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404136	\N	2025
7472	0.000970524000000	USD	t	LRS Class 1 Operations	7	STORAGE	Storage	2026-04-17 10:26:38.40415	\N	2025
7473	0.001682160000000	USD	t	LRS Data Stored	7	STORAGE	Storage	2026-04-17 10:26:38.404164	\N	2025
7474	0.000324360000000	USD	t	LRS List and Create Container Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404179	\N	2025
7475	0.602632920000000	USD	t	LRS Write Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404192	\N	2025
7476	0.021100350000000	USD	t	Protocol Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404207	\N	2025
7477	0.156000318000000	USD	t	Read Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404221	\N	2025
7478	0.000013896000000	USD	t	Scan Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404235	\N	2025
7479	0.000025632000000	USD	t	Write Operations	7	STORAGE	Storage	2026-04-17 10:26:38.404251	\N	2025
7480	47.830000000000000	USD	t	[RESERVATION] D2s v5	5	RESERVATION	Virtual Machines	2026-04-17 10:43:27.218241	\N	2025
7481	41.750000000000000	USD	t	[RESERVATION] D2ls v5	5	RESERVATION	Virtual Machines	2026-04-17 10:43:27.218263	\N	2025
7482	167.000000000000000	USD	t	[RESERVATION] D2ls v5	5	RESERVATION	Virtual Machines	2026-04-17 10:43:27.218279	\N	2025
7483	0.000083420000000	USD	t	All Other Operations	5	STORAGE	Storage	2026-04-17 10:43:27.218304	\N	2025
7484	0.000087768000000	USD	t	Batch Write Operations	5	STORAGE	Storage	2026-04-17 10:43:27.218331	\N	2025
7485	0.300113325000000	USD	t	LRS Data Stored	5	STORAGE	Storage	2026-04-17 10:43:27.218376	\N	2025
7486	0.299683200000000	USD	t	Snapshots LRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218421	\N	2025
7487	1.858087800000000	USD	t	E10 ZRS Disk Operations	5	DISK	Storage	2026-04-17 10:43:27.21844	\N	2025
7488	3.599769600000000	USD	t	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218446	\N	2025
7489	1.173689400000000	USD	f	E10 ZRS Disk Operations	5	DISK	Storage	2026-04-17 10:43:27.218455	1	2025
7490	3.599769600000000	USD	f	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218461	1	2025
7491	3.599769600000000	USD	f	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218467	2	2025
7492	1.535901696000000	USD	f	S4 LRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218488	2	2025
7493	0.007800250000000	USD	f	S4 LRS Disk Operations	5	DISK	Storage	2026-04-17 10:43:27.218506	2	2025
7494	2.332643200000000	USD	f	E10 ZRS Disk Operations	5	DISK	Storage	2026-04-17 10:43:27.218512	3	2025
7495	3.599769600000000	USD	f	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218519	3	2025
7496	2.394311800000000	USD	f	E10 ZRS Disk Operations	5	DISK	Storage	2026-04-17 10:43:27.218531	4	2025
7497	3.599769600000000	USD	f	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218537	4	2025
7498	3.599769600000000	USD	f	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218552	4	2025
7499	0.590797400000000	USD	f	E10 ZRS Disk Operations	5	DISK	Storage	2026-04-17 10:43:27.218579	5	2025
7500	3.599769600000000	USD	f	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218588	5	2025
7501	1.120554600000000	USD	f	E10 ZRS Disk Operations	5	DISK	Storage	2026-04-17 10:43:27.218594	7	2025
7502	3.599769600000000	USD	f	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218599	7	2025
7503	2.622311800000000	USD	f	E10 ZRS Disk Operations	5	DISK	Storage	2026-04-17 10:43:27.218607	6	2025
7504	3.599769600000000	USD	f	E4 ZRS Disk	5	DISK	Storage	2026-04-17 10:43:27.218613	6	2025
7505	0.516373200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218635	1	2025
7506	0.001314500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218654	1	2025
7507	0.033574700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218672	1	2025
7508	0.030808700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218691	1	2025
7509	0.034666250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218709	1	2025
7510	0.034847300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218726	1	2025
7511	0.032820700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218745	1	2025
7512	0.035434350000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218763	1	2025
7513	0.035000400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218781	1	2025
7514	0.040870400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218819	1	2025
7515	0.035944700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218848	1	2025
7516	0.038653200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218871	1	2025
7517	0.061089700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218889	1	2025
7518	0.035961300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218907	1	2025
7519	0.036389200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218925	1	2025
7520	0.043935900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218943	1	2025
7521	0.042342300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218964	1	2025
7522	0.039439250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.218997	1	2025
7523	0.051306000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219015	1	2025
7524	0.045996800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219033	1	2025
7525	0.038763300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219051	1	2025
7526	0.037271650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219071	1	2025
7527	0.041840300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.21909	1	2025
7528	0.043663200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219107	1	2025
7529	0.049113200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219125	1	2025
7530	0.058456900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219143	1	2025
7531	0.049130200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219161	1	2025
7532	0.034768650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219195	1	2025
7533	0.037347500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219212	1	2025
7534	0.036291000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219229	1	2025
7535	0.052170200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219247	1	2025
7536	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219267	1	2025
7537	0.047143550000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219285	1	2025
7538	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219303	1	2025
7539	0.035716450000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.21932	1	2025
7540	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219338	1	2025
7541	0.015672250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219357	1	2025
7542	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219375	1	2025
7543	0.004187500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219392	1	2025
7544	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.21941	1	2025
7545	0.004010850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219428	1	2025
7546	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219447	1	2025
7547	0.007849800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219465	1	2025
7548	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219483	1	2025
7549	0.004607000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219501	1	2025
7550	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219519	1	2025
7551	0.004075400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219536	1	2025
7552	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219554	1	2025
7553	0.015504500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219572	1	2025
7554	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.21959	1	2025
7555	0.009960300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.21961	1	2025
7556	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219627	1	2025
7557	0.003250800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219645	1	2025
7558	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219674	1	2025
7559	0.002921900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219694	1	2025
7560	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219714	1	2025
7561	0.008303750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219732	1	2025
7562	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.21975	1	2025
7563	0.005409050000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219767	1	2025
7564	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219787	1	2025
7565	0.005120400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219805	1	2025
7566	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219832	1	2025
7567	0.009074600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.21985	1	2025
7568	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219869	1	2025
7569	0.006318000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219889	1	2025
7570	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219908	1	2025
7571	0.002227750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219926	1	2025
7572	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219943	1	2025
7573	0.001906500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.21996	1	2025
7574	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219979	1	2025
7575	0.002649600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.219997	1	2025
7576	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220015	1	2025
7577	0.003300000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220032	1	2025
7578	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220049	1	2025
7579	0.001529600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220067	1	2025
7580	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220086	1	2025
7581	0.004935600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220104	1	2025
7582	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220122	1	2025
7583	0.004775000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22014	1	2025
7584	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220157	1	2025
7585	0.001102200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220175	1	2025
7586	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220193	1	2025
7587	0.000885600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220225	1	2025
7588	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220243	1	2025
7589	0.002659650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220261	1	2025
7590	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220279	1	2025
7591	0.001472500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220297	1	2025
7592	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220314	1	2025
7593	0.000467400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220333	1	2025
7594	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220351	1	2025
7595	0.001954500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220369	1	2025
7596	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220387	1	2025
7597	0.000498500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220407	1	2025
7598	0.016553100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220425	1	2025
7599	0.018440650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220442	1	2025
7600	0.018640900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220461	1	2025
7601	0.019077400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220478	1	2025
7602	0.019953400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220501	1	2025
7603	0.019624650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220519	1	2025
7604	0.020075000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220547	1	2025
7605	0.024727000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220574	1	2025
7606	0.023719250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220602	1	2025
7607	0.022386700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22063	1	2025
7608	0.021967250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220658	1	2025
7609	0.023052150000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220689	1	2025
7610	0.023132850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220716	1	2025
7611	0.022538000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220746	1	2025
7612	0.025071400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220775	1	2025
7613	0.027735550000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220805	1	2025
7614	0.026252100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220841	1	2025
7615	0.027399100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220873	1	2025
7616	0.028298500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220907	1	2025
7617	0.026252050000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220934	1	2025
7618	0.025548950000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220967	1	2025
7619	0.027153450000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.220985	1	2025
7620	0.041870850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221003	1	2025
7621	0.031617400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221021	1	2025
7622	0.031069600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221038	1	2025
7623	0.030654450000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221059	1	2025
7624	0.029882800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221076	1	2025
7625	0.023383950000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221094	1	2025
7626	0.031417000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221112	1	2025
7627	0.032220300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221129	1	2025
7628	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221149	1	2025
7629	0.034351600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221168	1	2025
7630	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221188	1	2025
7631	0.017191450000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221205	1	2025
7632	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221223	1	2025
7633	0.008032450000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221241	1	2025
7634	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221259	1	2025
7635	0.017244700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221277	1	2025
7636	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221296	1	2025
7637	0.013348800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221313	1	2025
7638	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221331	1	2025
7639	0.015419250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221348	1	2025
7640	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221367	1	2025
7641	0.016710000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221385	1	2025
7642	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221403	1	2025
7643	0.023977500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22142	1	2025
7644	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22144	1	2025
7645	0.026606400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221457	1	2025
7646	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221475	1	2025
7647	0.012638300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221493	1	2025
7648	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221524	1	2025
7649	0.010110300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221542	1	2025
7650	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22156	1	2025
7651	0.009077050000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221578	1	2025
7652	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221595	1	2025
7653	0.009120000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221613	1	2025
7654	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221632	1	2025
7655	0.009482400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221649	1	2025
7656	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221667	1	2025
7657	0.009666250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221684	1	2025
7658	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221703	1	2025
7659	0.007329400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221721	1	2025
7660	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221738	1	2025
7661	0.009441700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221756	1	2025
7662	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221773	1	2025
7663	0.007106400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22179	1	2025
7664	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221808	1	2025
7665	0.006064500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221834	1	2025
7666	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221851	1	2025
7667	0.005976000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221872	1	2025
7668	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22189	1	2025
7669	0.013071100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221907	1	2025
7670	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221925	1	2025
7671	0.006464950000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221942	1	2025
7672	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22196	1	2025
7673	0.006566400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221978	1	2025
7674	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.221996	1	2025
7675	0.004051200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222014	1	2025
7676	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222032	1	2025
7677	0.003351600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22205	1	2025
7678	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222068	1	2025
7679	0.002690900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222086	1	2025
7680	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222106	1	2025
7681	0.002898000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222123	1	2025
7682	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222142	1	2025
7683	0.002572800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222159	1	2025
7684	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222177	1	2025
7685	0.001807200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222194	1	2025
7686	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222212	1	2025
7687	0.001315200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22223	1	2025
7688	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222248	1	2025
7689	0.000717600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222266	1	2025
7690	0.001338700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222284	1	2025
7691	0.033560050000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222301	1	2025
7692	0.031731550000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222319	1	2025
7693	0.035193150000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222336	1	2025
7694	0.034238400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222355	1	2025
7695	0.033500050000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222373	1	2025
7696	0.036446750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222391	1	2025
7697	0.038545600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222408	1	2025
7698	0.039259350000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222425	1	2025
7699	0.036504300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222443	1	2025
7700	0.038795600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222461	1	2025
7701	0.038412900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222478	1	2025
7702	0.038565400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222496	1	2025
7703	0.039146100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222513	1	2025
7704	0.041054200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222531	1	2025
7705	0.042317600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222548	1	2025
7706	0.039447700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222566	1	2025
7707	0.044838750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222583	1	2025
7708	0.042089100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222601	1	2025
7709	0.044796800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222632	1	2025
7710	0.042383850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22265	1	2025
7711	0.045614000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222668	1	2025
7712	0.055986600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222685	1	2025
7713	0.049944200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222703	1	2025
7714	0.048781850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222721	1	2025
7715	0.053020850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222742	1	2025
7716	0.047491950000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222759	1	2025
7717	0.047915000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222777	1	2025
7718	0.046483550000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222794	1	2025
7719	0.057383250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222817	1	2025
7720	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222835	1	2025
7721	0.049608450000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222852	1	2025
7722	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222873	1	2025
7723	0.054599650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222891	1	2025
7724	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22291	1	2025
7725	0.023246400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222929	1	2025
7726	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222945	1	2025
7727	0.017043400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222961	1	2025
7728	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222977	1	2025
7729	0.016167600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.222995	1	2025
7730	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223011	1	2025
7731	0.015350400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223028	1	2025
7732	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223044	1	2025
7733	0.019500000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223089	1	2025
7734	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223108	1	2025
7735	0.019526400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223126	1	2025
7736	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223144	1	2025
7737	0.018271200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223162	1	2025
7738	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22319	1	2025
7739	0.014308800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223211	1	2025
7740	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22324	1	2025
7741	0.013381200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223274	1	2025
7742	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223293	1	2025
7743	0.012720000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223312	1	2025
7744	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22333	1	2025
7745	0.012517200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223347	1	2025
7746	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223365	1	2025
7747	0.010605600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223383	1	2025
7748	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223402	1	2025
7749	0.013484400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223423	1	2025
7750	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223446	1	2025
7751	0.013363200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223463	1	2025
7752	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223481	1	2025
7753	0.010872000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223499	1	2025
7754	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223516	1	2025
7755	0.009139150000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22354	1	2025
7756	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22357	1	2025
7757	0.007644000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223594	1	2025
7758	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223612	1	2025
7759	0.007243200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22363	1	2025
7760	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223651	1	2025
7761	0.008606400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223668	1	2025
7762	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223687	1	2025
7763	0.007524000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223705	1	2025
7764	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223722	1	2025
7765	0.005605200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223741	1	2025
7766	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223759	1	2025
7767	0.006112000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223777	1	2025
7768	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223794	1	2025
7769	0.004475600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223817	1	2025
7770	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223836	1	2025
7771	0.003549600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223854	1	2025
7772	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223871	1	2025
7773	0.004152000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223889	1	2025
7774	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223907	1	2025
7775	0.002318400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22393	1	2025
7776	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223948	1	2025
7777	0.002602800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223966	1	2025
7778	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.223984	1	2025
7779	0.001873650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224002	1	2025
7780	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22402	1	2025
7781	0.000813600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224039	1	2025
7782	0.001844200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224057	1	2025
7783	0.022147400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224074	1	2025
7784	0.021703950000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224092	1	2025
7785	0.028087150000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224109	1	2025
7786	0.031705800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224134	1	2025
7787	0.028453600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224157	1	2025
7788	0.027192500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224175	1	2025
7789	0.032405850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224192	1	2025
7790	0.028844750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22421	1	2025
7791	0.027364400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224227	1	2025
7792	0.040144000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224245	1	2025
7793	0.040343300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224262	1	2025
7794	0.036347800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224281	1	2025
7795	0.028794700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224299	1	2025
7796	0.040003600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224316	1	2025
7797	0.033834900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224334	1	2025
7798	0.032415100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224352	1	2025
7799	0.074284000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22437	1	2025
7800	0.059498900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224388	1	2025
7801	0.056224800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224406	1	2025
7802	0.029722350000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224423	1	2025
7803	0.033868300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224441	1	2025
7804	0.054169600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224458	1	2025
7805	0.043419350000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224476	1	2025
7806	0.076210900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224493	1	2025
7807	0.065869750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224511	1	2025
7808	0.056284200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224528	1	2025
7809	0.034238750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224546	1	2025
7810	0.038630700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224563	1	2025
7811	0.042694100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224581	1	2025
7812	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224599	1	2025
7813	0.066142600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224617	1	2025
7814	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224635	1	2025
7815	0.038225200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224653	1	2025
7816	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22467	1	2025
7817	0.070609200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224688	1	2025
7818	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224706	1	2025
7819	0.037787300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224724	1	2025
7820	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224741	1	2025
7821	0.011566800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224759	1	2025
7822	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224776	1	2025
7823	0.013603200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224794	1	2025
7824	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224817	1	2025
7825	0.017370000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224834	1	2025
7826	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224851	1	2025
7827	0.015234800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224869	1	2025
7828	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22489	1	2025
7829	0.054372000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224908	1	2025
7830	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224925	1	2025
7831	0.053433600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224942	1	2025
7832	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224959	1	2025
7833	0.026558400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224978	1	2025
7834	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.224996	1	2025
7835	0.004464000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225013	1	2025
7836	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225031	1	2025
7837	0.013794000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225049	1	2025
7838	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225067	1	2025
7839	0.013089600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225085	1	2025
7840	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225103	1	2025
7841	0.011714200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225121	1	2025
7842	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225138	1	2025
7843	0.030067200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225156	1	2025
7844	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225174	1	2025
7845	0.029455950000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225193	1	2025
7846	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22521	1	2025
7847	0.020783150000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225228	1	2025
7848	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22525	1	2025
7849	0.007160400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22528	1	2025
7850	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225309	1	2025
7851	0.006062400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225338	1	2025
7852	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225365	1	2025
7853	0.013347250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225382	1	2025
7854	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.2254	1	2025
7855	0.008004000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225418	1	2025
7856	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225436	1	2025
7857	0.017982000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225456	1	2025
7858	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225474	1	2025
7859	0.013570550000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225492	1	2025
7860	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225525	1	2025
7861	0.008876050000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225543	1	2025
7862	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22556	1	2025
7863	0.002505600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225578	1	2025
7864	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225596	1	2025
7865	0.001320000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225614	1	2025
7866	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225632	1	2025
7867	0.003628800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22565	1	2025
7868	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225667	1	2025
7869	0.002138400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225684	1	2025
7870	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225702	1	2025
7871	0.005152800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225719	1	2025
7872	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225738	1	2025
7873	0.002455200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225756	1	2025
7874	0.000595100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225773	1	2025
7875	0.014997400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225791	1	2025
7876	0.014770650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225808	1	2025
7877	0.015854350000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225829	1	2025
7878	0.016057200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225847	1	2025
7879	0.015917300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225865	1	2025
7880	0.016743150000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225883	1	2025
7881	0.016625250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225902	1	2025
7882	0.019828650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22592	1	2025
7883	0.021832300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225937	1	2025
7884	0.018673650000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225956	1	2025
7885	0.018470800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.225973	1	2025
7886	0.018270700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22599	1	2025
7887	0.018535200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226008	1	2025
7888	0.020426200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226026	1	2025
7889	0.023779500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226045	1	2025
7890	0.019022200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226062	1	2025
7891	0.022235000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226079	1	2025
7892	0.021430550000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226096	1	2025
7893	0.021848800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226115	1	2025
7894	0.020459950000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226133	1	2025
7895	0.022463250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226152	1	2025
7896	0.022949400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226169	1	2025
7897	0.041135300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226187	1	2025
7898	0.025099400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226205	1	2025
7899	0.021640600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226223	1	2025
7900	0.023295500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22624	1	2025
7901	0.024665000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226258	1	2025
7902	0.023485000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226276	1	2025
7903	0.029652750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226294	1	2025
7904	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226311	1	2025
7905	0.025736200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22633	1	2025
7906	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226347	1	2025
7907	0.025109700000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226365	1	2025
7908	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226384	1	2025
7909	0.013795750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226403	1	2025
7910	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22642	1	2025
7911	0.010493050000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22644	1	2025
7912	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226458	1	2025
7913	0.009797000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226476	1	2025
7914	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226493	1	2025
7915	0.009594200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226511	1	2025
7916	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226528	1	2025
7917	0.015663850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226546	1	2025
7918	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226563	1	2025
7919	0.016416400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22658	1	2025
7920	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226602	1	2025
7921	0.023111550000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22663	1	2025
7922	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226649	1	2025
7923	0.010408250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226667	1	2025
7924	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226684	1	2025
7925	0.008525850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226702	1	2025
7926	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22672	1	2025
7927	0.007568200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226739	1	2025
7928	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226756	1	2025
7929	0.008030750000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226775	1	2025
7930	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226792	1	2025
7931	0.007046850000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226813	1	2025
7932	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226831	1	2025
7933	0.007631250000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226848	1	2025
7934	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226865	1	2025
7935	0.007449350000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226883	1	2025
7936	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226901	1	2025
7937	0.007251800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226919	1	2025
7938	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226937	1	2025
7939	0.005527500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226955	1	2025
7940	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226973	1	2025
7941	0.004774000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.226994	1	2025
7942	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227012	1	2025
7943	0.004706800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22703	1	2025
7944	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227049	1	2025
7945	0.007456050000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227066	1	2025
7946	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227084	1	2025
7947	0.010778900000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227101	1	2025
7948	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227119	1	2025
7949	0.003466800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227137	1	2025
7950	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227155	1	2025
7951	0.003457100000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227173	1	2025
7952	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22719	1	2025
7953	0.002655300000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227207	1	2025
7954	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227225	1	2025
7955	0.002210200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227244	1	2025
7956	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227261	1	2025
7957	0.001838550000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227278	1	2025
7958	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227295	1	2025
7959	0.002088450000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227313	1	2025
7960	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22733	1	2025
7961	0.001614500000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227348	1	2025
7962	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227371	1	2025
7963	0.001021000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227399	1	2025
7964	0.000001900000000	USD	f	S4 LRS Disk Operations	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227427	1	2025
7965	0.000492000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227457	1	2025
7966	0.424749600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227484	1	2025
7967	0.013764000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227512	1	2025
7968	0.013578000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227541	1	2025
7969	0.033219600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227569	1	2025
7970	0.012908400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.2276	1	2025
7971	0.010192800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227628	1	2025
7972	0.011792400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227658	1	2025
7973	0.015028800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227686	1	2025
7974	0.014136000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227716	1	2025
7975	0.008890800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227742	1	2025
7976	0.012462000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.22776	1	2025
7977	0.006547200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227777	1	2025
7978	0.011085600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227795	1	2025
7979	0.021204000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227817	1	2025
7980	0.012350400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227834	1	2025
7981	0.012759600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227851	1	2025
7982	0.014433600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227869	1	2025
7983	0.016293600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227887	1	2025
7984	0.010527600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227904	1	2025
7985	0.011048400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227922	1	2025
7986	0.012090000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227939	1	2025
7987	0.016144800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227957	1	2025
7988	0.012276000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227974	1	2025
7989	0.013652400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.227992	1	2025
7990	0.015475200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.228009	1	2025
7991	0.012164400000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.228027	1	2025
7992	0.006175200000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.228044	1	2025
7993	0.013168800000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.228062	1	2025
7994	0.010788000000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.228079	1	2025
7995	0.014061600000000	USD	f	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.228097	1	2025
7996	0.996811200000000	USD	t	Snapshots ZRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.228111	\N	2025
7997	0.271522800000000	USD	t	Snapshots LRS Snapshots	5	SNAPSHOT	Storage	2026-04-17 10:43:27.228122	\N	2025
7998	0.000012363549322	USD	t	Intra Continent Data Transfer Out	5	VM	Bandwidth	2026-04-17 10:43:27.228147	\N	2025
7999	0.000009814649820	USD	f	Intra Continent Data Transfer Out	5	VM	Bandwidth	2026-04-17 10:43:27.228155	1	2025
8000	0.291000000000000	USD	f	D2ls v5	5	VM	Virtual Machines	2026-04-17 10:43:27.228158	1	2025
8001	0.000012989006937	USD	f	Intra Continent Data Transfer Out	5	VM	Bandwidth	2026-04-17 10:43:27.228166	3	2025
8002	0.000012389365584	USD	f	Intra Continent Data Transfer Out	5	VM	Bandwidth	2026-04-17 10:43:27.228172	4	2025
8003	0.000240760482848	USD	f	Intra Continent Data Transfer Out	5	VM	Bandwidth	2026-04-17 10:43:27.228178	5	2025
8004	0.000026109069586	USD	f	Intra Continent Data Transfer Out	5	VM	Bandwidth	2026-04-17 10:43:27.228183	6	2025
8005	0.097000000000000	USD	f	D2ls v5	5	VM	Virtual Machines	2026-04-17 10:43:27.228187	6	2025
8006	0.000011108815670	USD	f	Intra Continent Data Transfer Out	5	VM	Bandwidth	2026-04-17 10:43:27.228192	7	2025
8007	18.769538800000000	USD	f	D2ls v5	5	VM	Virtual Machines	2026-04-17 10:43:27.228198	7	2025
8008	0.327016129032258	USD	t	Alerts Metric Monitored	5	ALERT	Azure Monitor	2026-04-17 10:43:27.228218	\N	2025
8009	0.325806451612904	USD	t	Alerts Metric Monitored	5	ALERT	Azure Monitor	2026-04-17 10:43:27.228234	\N	2025
8010	0.287096774193548	USD	t	Alerts Metric Monitored	5	ALERT	Azure Monitor	2026-04-17 10:43:27.22825	\N	2025
8011	0.327016129032258	USD	t	Alerts Metric Monitored	5	ALERT	Azure Monitor	2026-04-17 10:43:27.228266	\N	2025
8012	0.295914519019425	USD	f	Standard Traffic Analytics Processing	5	NSG	Network Watcher	2026-04-17 10:43:27.228282	4	2025
8013	0.172335322387516	USD	t	Standard Traffic Analytics Processing	5	NSG	Network Watcher	2026-04-17 10:43:27.228299	\N	2025
8014	3.720000000000000	USD	t	Standard IPv4 Static Public IP	5	PUBLIC_IP	Virtual Network	2026-04-17 10:43:27.228315	\N	2025
8015	3.720000000000000	USD	f	Standard IPv4 Static Public IP	5	PUBLIC_IP	Virtual Network	2026-04-17 10:43:27.22833	3	2025
8016	3.720000000000000	USD	f	Standard IPv4 Static Public IP	5	PUBLIC_IP	Virtual Network	2026-04-17 10:43:27.228346	4	2025
8017	3.720000000000000	USD	f	Standard IPv4 Static Public IP	5	PUBLIC_IP	Virtual Network	2026-04-17 10:43:27.228362	4	2025
8018	3.720000000000000	USD	f	Standard IPv4 Static Public IP	5	PUBLIC_IP	Virtual Network	2026-04-17 10:43:27.228378	6	2025
8019	0.613688900760000	USD	t	Analytics Logs Data Ingestion	5	LOG_ANALYTICS	Log Analytics	2026-04-17 10:43:27.228392	\N	2025
8020	1.700563519590000	USD	t	Analytics Logs Data Ingestion	5	LOG_ANALYTICS	Log Analytics	2026-04-17 10:43:27.228407	\N	2025
8021	5.836673548680000	USD	f	Analytics Logs Data Ingestion	5	LOG_ANALYTICS	Log Analytics	2026-04-17 10:43:27.228422	4	2025
8022	1.948311358500000	USD	f	Analytics Logs Data Ingestion	5	LOG_ANALYTICS	Log Analytics	2026-04-17 10:43:27.228437	6	2025
8023	0.000002320000000	USD	t	Intra Continent Data Transfer Out	5	STORAGE	Bandwidth	2026-04-17 10:43:27.228451	\N	2025
8024	0.023809500000000	USD	t	Account Encrypted Batch Write Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228465	\N	2025
8025	0.002975170000000	USD	t	All Other Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228479	\N	2025
8026	0.006140060000000	USD	t	Cool Data Retrieval	5	STORAGE	Storage	2026-04-17 10:43:27.228494	\N	2025
8027	0.001808230000000	USD	t	Cool LRS Data Stored	5	STORAGE	Storage	2026-04-17 10:43:27.228508	\N	2025
8028	2.722690000000000	USD	t	Cool LRS Write Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228523	\N	2025
8029	0.006727000000000	USD	t	Cool Read Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228537	\N	2025
8030	0.000078840000000	USD	t	LRS Data Stored	5	STORAGE	Storage	2026-04-17 10:43:27.228552	\N	2025
8031	0.012430800000000	USD	t	LRS List and Create Container Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228566	\N	2025
8032	0.000089892000000	USD	t	Batch Write Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228581	\N	2025
8033	0.056499768000000	USD	t	Class 2 Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228595	\N	2025
8034	0.000005004000000	USD	t	Delete Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228609	\N	2025
8035	0.000970308000000	USD	t	LRS Class 1 Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228623	\N	2025
8036	0.002302020000000	USD	t	LRS Data Stored	5	STORAGE	Storage	2026-04-17 10:43:27.228638	\N	2025
8037	0.000241704000000	USD	t	LRS List and Create Container Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228652	\N	2025
8038	0.528749196000000	USD	t	LRS Write Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228666	\N	2025
8039	0.014069100000000	USD	t	Protocol Operations	5	STORAGE	Storage	2026-04-17 10:43:27.22868	\N	2025
8040	0.119389794000000	USD	t	Read Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228694	\N	2025
8041	0.000015660000000	USD	t	Scan Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228708	\N	2025
8042	0.000005004000000	USD	t	Write Operations	5	STORAGE	Storage	2026-04-17 10:43:27.228722	\N	2025
\.


--
-- Data for Name: monthly_vm_costs; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.monthly_vm_costs (id, availability_percent, calculated_at, direct_cost, month, reservation_cost, shared_cost, total_cost, year, vm_id) FROM stdin;
29	100	2026-04-05 14:59:57.764117	8.514794346000000	2	0.000000000000000	1.908870317456701	10.423664663456701	2026	2
30	100	2026-04-05 14:59:57.764135	10.143274272641754	2	41.750000000000000	1.908870317456701	53.802144590098455	2026	3
31	100	2026-04-05 14:59:57.76414	4.959865257774574	2	0.000000000000000	1.908870317456701	6.868735575231275	2026	5
32	100	2026-04-05 14:59:57.764144	10.717423171663817	2	41.750000000000000	1.908870317456701	54.376293489120518	2026	6
33	100	2026-04-05 14:59:57.764148	38.750596407751942	2	41.750000000000000	1.908870317456701	82.409466725208643	2026	7
34	100	2026-04-05 14:59:57.764151	7.958004311094508	2	41.750000000000000	1.908870317456701	51.616874628551209	2026	1
35	100	2026-04-05 14:59:57.764154	22.908673220629978	2	47.830000000000000	1.908870317456701	72.647543538086679	2026	4
43	100	2026-04-17 09:30:55.008183	10.320654443938041	3	41.750000000000000	1.093848860740446	53.164503304678487	2026	3
44	100	2026-04-17 09:30:55.008187	25.663405466323084	3	47.830000000000000	1.093848860740446	74.587254327063530	2026	4
45	100	2026-04-17 09:30:55.008189	12.400869090171962	3	41.750000000000000	1.093848860740446	55.244717950912408	2026	6
46	100	2026-04-17 09:30:55.00819	29.708303538283806	3	41.750000000000000	1.093848860740446	72.552152399024252	2026	7
47	100	2026-04-17 09:30:55.008199	8.908837316990825	3	0.000000000000000	1.093848860740446	10.002686177731271	2026	2
48	100	2026-04-17 09:30:55.0082	4.856734758615144	3	0.000000000000000	1.093848860740446	5.950583619355590	2026	5
49	100	2026-04-17 09:30:55.008201	22.511510938973017	3	41.750000000000000	1.093848860740446	65.355359799713463	2026	1
50	100	2026-04-17 09:32:47.212123	10.536531771892977	1	41.750000000000000	2.077090649385290	54.363622421278267	2026	3
51	100	2026-04-17 09:32:47.212127	24.950039542369690	1	47.830000000000000	2.077090649385290	74.857130191754980	2026	4
52	100	2026-04-17 09:32:47.212128	11.292030468132523	1	41.750000000000000	2.077090649385290	55.119121117517813	2026	6
53	100	2026-04-17 09:32:47.212129	28.795336567080235	1	41.750000000000000	2.077090649385290	72.622427216465525	2026	7
54	100	2026-04-17 09:32:47.212131	8.881712446000000	1	0.000000000000000	2.077090649385290	10.958803095385290	2026	2
55	100	2026-04-17 09:32:47.212132	4.622177718744624	1	0.000000000000000	2.077090649385290	6.699268368129914	2026	5
56	100	2026-04-17 09:32:47.212133	19.664243492191706	1	41.750000000000000	2.077090649385290	63.491334141576996	2026	1
57	100	2026-04-17 09:41:33.96338	10.307545940553796	12	41.750000000000000	2.096245226165642	54.153791166719438	2025	3
58	100	2026-04-17 09:41:33.963385	24.999536364812570	12	47.830000000000000	2.096245226165642	74.925781590978212	2025	4
59	100	2026-04-17 09:41:33.963386	12.985917048466276	12	41.750000000000000	2.096245226165642	56.832162274631918	2025	6
60	100	2026-04-17 09:41:33.963387	31.648334767021952	12	41.750000000000000	2.096245226165642	75.494579993187594	2025	7
61	100	2026-04-17 09:41:33.963388	8.895485477292439	12	0.000000000000000	2.096245226165642	10.991730703458081	2025	2
62	100	2026-04-17 09:41:33.963389	4.434357164143378	12	0.000000000000000	2.096245226165642	6.530602390309020	2025	5
63	100	2026-04-17 09:41:33.96339	20.002843737196803	12	41.750000000000000	2.096245226165642	63.849088963362445	2025	1
64	100	2026-04-17 09:47:19.711043	10.258595123601675	11	41.750000000000000	2.031075747973937	54.039670871575612	2025	3
65	100	2026-04-17 09:47:19.711047	23.908474006106410	11	47.830000000000000	2.031075747973937	73.769549754080347	2025	4
66	100	2026-04-17 09:47:19.711048	14.139219999707026	11	41.750000000000000	2.031075747973937	57.920295747680963	2025	6
67	100	2026-04-17 09:47:19.711049	28.295669644618043	11	41.750000000000000	2.031075747973937	72.076745392591980	2025	7
68	100	2026-04-17 09:47:19.711051	7.553595176273429	11	0.000000000000000	2.031075747973937	9.584670924247366	2025	2
69	100	2026-04-17 09:47:19.711052	4.341948379702115	11	0.000000000000000	2.031075747973937	6.373024127676052	2025	5
70	100	2026-04-17 09:47:19.711053	16.592123764728494	11	41.750000000000000	2.031075747973937	60.373199512702431	2025	1
71	100	2026-04-17 09:50:30.047363	10.061349331552768	10	41.750000000000000	2.120913676327240	53.932263007880008	2025	3
72	100	2026-04-17 09:50:30.047369	23.082886944918886	10	47.830000000000000	2.120913676327240	73.033800621246126	2025	4
73	100	2026-04-17 09:50:30.04737	11.833287168976332	10	41.750000000000000	2.120913676327240	55.704200845303572	2025	6
74	100	2026-04-17 09:50:30.047371	28.133988807650840	10	41.750000000000000	2.120913676327240	72.004902483978080	2025	7
75	100	2026-04-17 09:50:30.047373	5.155426596000000	10	0.000000000000000	2.120913676327240	7.276340272327240	2025	2
76	100	2026-04-17 09:50:30.047374	5.991786383661182	10	0.000000000000000	2.120913676327240	8.112700059988422	2025	5
77	100	2026-04-17 09:50:30.047375	14.420200388828750	10	41.750000000000000	2.120913676327240	58.291114065155990	2025	1
78	100	2026-04-17 10:02:58.310991	9.889797820903982	9	41.750000000000000	2.479046754768561	54.118844575672543	2025	3
79	100	2026-04-17 10:02:58.310996	22.872932199183744	9	47.830000000000000	2.479046754768561	73.181978953952305	2025	4
80	100	2026-04-17 10:02:58.310998	31.638982414575175	9	41.750000000000000	2.479046754768561	75.868029169343736	2025	6
81	100	2026-04-17 10:02:58.310999	69.644777007848120	9	41.750000000000000	2.479046754768561	113.873823762616681	2025	7
82	100	2026-04-17 10:02:58.311001	5.147493880000000	9	0.000000000000000	2.479046754768561	7.626540634768561	2025	2
83	100	2026-04-17 10:02:58.311002	5.695985803952432	9	0.000000000000000	2.479046754768561	8.175032558720993	2025	5
84	100	2026-04-17 10:02:58.311003	17.016642724320507	9	41.750000000000000	2.479046754768561	61.245689479089068	2025	1
85	100	2026-04-17 10:04:14.379097	9.708904638558042	8	41.750000000000000	2.581440655756615	54.040345294314657	2025	3
86	100	2026-04-17 10:04:14.379103	23.235684947775084	8	47.830000000000000	2.581440655756615	73.647125603531699	2025	4
87	100	2026-04-17 10:04:14.379104	12.586199423757707	8	41.750000000000000	2.581440655756615	56.917640079514322	2025	6
88	100	2026-04-17 10:04:14.379105	29.849932027944298	8	41.750000000000000	2.581440655756615	74.181372683700913	2025	7
89	100	2026-04-17 10:04:14.379107	5.143485746000000	8	0.000000000000000	2.581440655756615	7.724926401756615	2025	2
90	100	2026-04-17 10:04:14.379108	5.439981133423800	8	0.000000000000000	2.581440655756615	8.021421789180415	2025	5
91	100	2026-04-17 10:04:14.379109	14.222007465194764	8	41.750000000000000	2.581440655756615	58.553448120951379	2025	1
92	100	2026-04-17 10:26:49.422774	9.636532095330119	7	52.187500000000000	2.579967332117835	64.403999427447954	2025	3
93	100	2026-04-17 10:26:49.422787	23.331022580666391	7	47.830000000000000	2.579967332117835	73.740989912784226	2025	4
94	100	2026-04-17 10:26:49.422789	13.057997890822406	7	52.187500000000000	2.579967332117835	67.825465222940241	2025	6
95	100	2026-04-17 10:26:49.422791	28.318492682695870	7	52.187500000000000	2.579967332117835	83.085960014813705	2025	7
96	100	2026-04-17 10:26:49.422808	5.143456296000000	7	0.000000000000000	2.579967332117835	7.723423628117835	2025	2
97	100	2026-04-17 10:26:49.422818	4.584545426778042	7	0.000000000000000	2.579967332117835	7.164512758895877	2025	5
98	100	2026-04-17 10:26:49.422819	13.993744387206998	7	52.187500000000000	2.579967332117835	68.761211719324833	2025	1
99	100	2026-04-17 10:43:39.84163	9.652425789006937	5	52.187500000000000	2.614099153308258	64.454024942315195	2025	3
100	100	2026-04-17 10:43:39.841636	23.166451457065009	5	47.830000000000000	2.614099153308258	73.610550610373267	2025	4
101	100	2026-04-17 10:43:39.841637	11.987418867569586	5	52.187500000000000	2.614099153308258	66.789018020877844	2025	6
102	100	2026-04-17 10:43:39.841638	23.489874108815670	5	52.187500000000000	2.614099153308258	78.291473262123928	2025	7
103	100	2026-04-17 10:43:39.84164	5.143471546000000	5	0.000000000000000	2.614099153308258	7.757570699308258	2025	2
104	100	2026-04-17 10:43:39.841641	4.190807760482848	5	0.000000000000000	2.614099153308258	6.804906913791106	2025	5
105	100	2026-04-17 10:43:39.841642	13.171637964649820	5	52.187500000000000	2.614099153308258	67.973237117958078	2025	1
\.


--
-- Data for Name: performance_metrics; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.performance_metrics (id, availability_percent, cpu_avg, cpu_max, cpu_min, disk_avg, disk_max, disk_min, ram_avg, ram_max, ram_min, saved_at, vm_id, disk_read, disk_write, network_in, network_out) FROM stdin;
372	100	3.932966101694915	15.14	2.28	\N	\N	\N	3.802916445974576	3.83642578125	3.77197265625	2026-04-21 17:00:01.746532	4	0.009306998172048794	0.24912461183838924	0.2717328707377116	5.038111766179402
373	100	1.0802586206896552	34.13	0.455	\N	\N	\N	2.8489527209051726	2.87451171875	2.74560546875	2026-04-21 17:00:02.217598	7	9.930335869223385e-06	0.02729502807229252	0.07053901354471842	0.2346990426381429
374	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 17:00:02.956483	2	\N	\N	\N	\N
375	100	1.2895762711864405	1.705	1.17	\N	\N	\N	0.8574798066737288	0.87451171875	0.84375	2026-04-21 17:00:03.339918	3	2.3168143579515362e-05	0.04921988729703225	0.07612113952636719	0.1794479211171468
376	100	2.1321929824561403	29.905	1.405	\N	\N	\N	2.8496921345338984	2.861328125	2.6943359375	2026-04-21 17:00:03.552933	1	0.00886109966342732	0.17015544277126507	0.07356570561726888	0.3188769817352295
377	100	1.0284745762711864	7.535	0.815	\N	\N	\N	2.619686837923729	2.6416015625	2.58349609375	2026-04-21 17:00:04.364971	6	0	0.16645370993120917	0.5209708690643311	0.3178683280944824
746	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 16:01:05.080864	2	\N	\N	\N	\N
87	100	0.91225	1.545	0.755	0	0	0	2.623909505208333	2.6513671875	2.6103515625	2026-04-16 18:19:31.560556	6	0	\N	\N	\N
88	100	1.1028813559322035	34.095	0.475	0	0	0	2.778518935381356	2.796875	2.55712890625	2026-04-16 18:19:31.998209	7	0	\N	\N	\N
90	100	1.7595833333333333	38.02	0.965	7425.778135593221	233418.63	0	2.055810546875	2.083984375	1.87548828125	2026-04-16 18:19:32.49818	5	0.2226053524017334	\N	\N	\N
91	100	2.2952586206896552	33.75	1.43	35303.882033898306	1448595.54	0	2.7243114406779663	2.74951171875	2.6474609375	2026-04-16 18:19:32.691388	1	1.3814883613586426	\N	\N	\N
92	100	2.3404237288135596	42.305	1.235	8920.431864406779	304361.59	0	0.7665105270127118	0.7939453125	0.74560546875	2026-04-16 19:00:00.56721	3	0.29026183128356936	\N	\N	\N
93	100	2.35364406779661	4.965	2.215	10599.643050847457	543401.44	341.3	3.994198556673729	4.0166015625	3.96728515625	2026-04-16 19:00:00.831537	4	0.5182279968261718	\N	\N	\N
94	100	0.885593220338983	1.53	0.755	44.715862068965514	2593.52	0	2.6196206302966103	2.63818359375	2.6103515625	2026-04-16 19:00:01.149726	6	0.0024733734130859375	\N	\N	\N
95	100	1.1139655172413794	34.53	0.46	9.256271186440678	546.12	0	2.7705414870689653	2.7900390625	2.57861328125	2026-04-16 19:00:01.608679	7	0.0005208206176757813	\N	\N	\N
97	96.96969696969697	2.32453125	38.02	0.965	7313.529375	233418.63	0	2.0481414794921875	2.08544921875	1.87548828125	2026-04-16 19:00:02.303425	5	0.2226053524017334	\N	\N	\N
98	100	2.146607142857143	17.7875	1.44	32746.69372881356	895293.96	0	2.7157458289194913	2.73779296875	2.630859375	2026-04-16 19:00:02.478087	1	0.8538188552856445	\N	\N	\N
99	100	2.094322033898305	14.325	1.21	2737.212372881356	104090.01	0	0.7642015360169492	0.7861328125	0.7451171875	2026-04-16 20:00:01.494524	3	0.09926796913146972	\N	\N	\N
100	100	2.3371186440677962	3.64	2.245	10129.64406779661	541268.08	273.02	4.010858050847458	4.0361328125	3.99609375	2026-04-16 20:00:01.703116	4	0.5161934661865234	\N	\N	\N
101	100	0.9261016949152543	1.5	0.785	0	0	0	2.6130577992584745	2.626953125	2.59716796875	2026-04-16 20:00:02.012158	6	0	\N	\N	\N
102	100	1.1088793103448276	34.735	0.47	3840.5996610169486	225776.3	0	2.7450582570043105	2.7685546875	2.5380859375	2026-04-16 20:00:02.250891	7	0.2153170585632324	\N	\N	\N
105	100	2.2753389830508475	33.185	1.41	28569.04745762712	1440900.98	0	2.7071884931144066	2.73486328125	2.626953125	2026-04-16 20:00:03.034666	1	1.3741502571105957	\N	\N	\N
106	100	5.751864406779661	67.64	1.135	775.1777966101695	10512.89	0	0.7644167108050848	0.7822265625	0.7509765625	2026-04-17 10:00:01.37168	3	0.010025873184204101	\N	\N	\N
107	100	2.600338983050847	6.78	2.235	10054.809830508473	540948.32	0	4.0072993908898304	4.029296875	3.98876953125	2026-04-17 10:00:01.710634	4	0.5158885192871093	\N	\N	\N
108	100	1.0628813559322035	2.225	0.85	100.02896551724139	2388.68	0	2.640285685911017	2.6904296875	2.6142578125	2026-04-17 10:00:02.129604	6	0.002278022766113281	\N	\N	\N
109	100	1.102844827586207	34.7	0.465	600.4411864406779	20749.47	0	2.815783270474138	2.84033203125	2.72509765625	2026-04-17 10:00:02.417196	7	0.019788236618041993	\N	\N	\N
111	100	1.7076724137931034	32.2	0.93	5280.7567796610165	243033.5	0	2.2245336072198274	2.26220703125	2.142578125	2026-04-17 10:00:03.059747	5	0.23177480697631836	\N	\N	\N
112	100	2.4982485875706217	36.41	1.43	28762.2286440678	527307.51	0	2.9059520656779663	2.94482421875	2.81640625	2026-04-17 10:00:03.44177	1	0.5028796291351318	\N	\N	\N
113	100	6.202033898305085	42.9	1.2	3026.5533898305084	149147.4	0	0.7489158501059322	0.7783203125	0.716796875	2026-04-17 11:00:01.896686	3	0.14223804473876953	\N	\N	\N
114	100	2.40364406779661	4.515	2.225	9958.612711864407	539777.81	68.25	4.01270358845339	4.02978515625	3.99462890625	2026-04-17 11:00:02.400492	4	0.5147722339630127	\N	\N	\N
115	100	1.0522881355932203	5.24	0.84	208.34793103448277	9831.69	0	2.631744902012712	2.66015625	2.57958984375	2026-04-17 11:00:02.722963	6	0.009376230239868165	\N	\N	\N
116	100	1.072966101694915	34.415	0.46	0	0	0	2.74363579184322	2.8232421875	2.6064453125	2026-04-17 11:00:03.17752	7	0	\N	\N	\N
118	100	1.713103448275862	31.4	0.93	4718.54	248223.82	0	2.2156465174788136	2.2509765625	2.1337890625	2026-04-17 11:00:04.555947	5	0.23672468185424805	\N	\N	\N
119	100	2.214363636363636	18.9625	1.45	253462.15	12275169.79	0	2.803576239224138	2.845703125	2.70263671875	2026-04-17 11:00:05.109676	1	11.7065141582489	\N	\N	\N
120	100	18.16822033898305	65.4	1.095	24264.313220338983	1111693.41	0	0.7506951800847458	0.77783203125	0.73095703125	2026-04-17 12:00:05.437761	3	1.060193452835083	\N	\N	\N
121	100	2.3720338983050846	3.615	2.24	9784.045084745763	540808.68	0	4.02145127118644	4.0439453125	4.0029296875	2026-04-17 12:00:05.682208	4	0.5157553482055665	\N	\N	\N
122	100	0.9501694915254237	1.54	0.805	0	0	0	2.6185530323093222	2.6513671875	2.607421875	2026-04-17 12:00:06.284833	6	0	\N	\N	\N
123	100	1.087758620689655	34.66	0.465	0	0	0	2.7163422683189653	2.73388671875	2.611328125	2026-04-17 12:00:06.974903	7	0	\N	\N	\N
125	100	1.6908620689655172	30.615	0.925	4919.30406779661	253247.34	0	2.2008519665948274	2.236328125	2.1240234375	2026-04-17 12:00:07.983412	5	0.24151548385620117	\N	\N	\N
126	100	2.785357142857143	37.415	1.39	25311.22084745763	527694.22	0	2.764471646012931	2.787109375	2.68359375	2026-04-17 12:00:08.422612	1	0.5032484245300293	\N	\N	\N
127	100	3.2822033898305087	21.52	2.225	10662.778135593218	528971.94	0	3.9630064883474576	3.98779296875	3.94287109375	2026-04-17 15:00:01.913215	4	0.5044669532775878	\N	\N	\N
128	100	1.1068103448275861	33.69	0.475	0	0	0	2.713732489224138	2.751953125	2.62109375	2026-04-17 15:00:02.717822	7	0	\N	\N	\N
130	100	1.6917241379310346	29.45	0.92	4557.206949152543	268533.95	0	2.158716662176724	2.19775390625	2.07861328125	2026-04-17 15:00:03.395288	5	0.25609393119812013	\N	\N	\N
131	100	5.44042372881356	33.06	1.22	2059.272033898305	28328.82	0	0.7499089645127118	0.78173828125	0.7294921875	2026-04-17 15:00:03.729269	3	0.027016468048095703	\N	\N	\N
132	100	2.7737719298245613	35.96	1.445	26708.40033898305	1008141.95	0	2.724915585275424	2.75244140625	2.6533203125	2026-04-17 15:00:04.091457	1	0.9614390850067138	\N	\N	\N
133	100	0.9413559322033899	2.345	0.82	0	0	0	2.6277227886652543	2.6474609375	2.5927734375	2026-04-17 15:00:04.552712	6	0	\N	\N	\N
134	100	4.992118644067797	31.745	2.22	10115.522372881356	525487.79	0	3.962096133474576	3.98681640625	3.939453125	2026-04-17 17:01:02.247902	4	0.5011442089080811	\N	\N	\N
135	100	1.1112931034482758	33.725	0.48	55.53305084745762	3276.45	0	2.734332906788793	2.755859375	2.6416015625	2026-04-17 17:01:02.56241	7	0.0031246662139892576	\N	\N	\N
137	100	1.682767857142857	27.37	0.89	4925.516666666666	280686.21	0	2.128983347039474	2.15283203125	2.04345703125	2026-04-17 17:01:03.147495	5	0.26768322944641115	\N	\N	\N
138	100	3.545847457627119	42.005	1.16	12175.627627118645	500343.1	0	0.7339280985169492	0.75390625	0.689453125	2026-04-17 17:01:03.73077	3	0.47716436386108396	\N	\N	\N
139	100	2.572276785714286	38.28	1.395	164629.53932203387	7527028.89	0	2.7144985856681036	2.74267578125	2.64111328125	2026-04-17 17:01:04.088961	1	7.178334131240844	\N	\N	\N
140	100	0.9588135593220339	1.47	0.8	0	0	0	2.6127184851694913	2.6474609375	2.6015625	2026-04-17 17:01:04.834365	6	0	\N	\N	\N
141	100	4.979661016949152	11.69	2.27	10386.991525423731	544231.9	273.06	3.9967061705508473	4.04345703125	3.88671875	2026-04-18 14:00:02.015503	4	0.5190199851989746	\N	\N	\N
142	100	1.1336206896551724	34.27	0.49	639.7464406779661	18156.65	0	2.878241177262931	2.8974609375	2.76904296875	2026-04-18 14:00:02.834819	7	0.01731553077697754	\N	\N	\N
145	100	1.3332203389830508	1.84	1.135	134.20338983050848	4231.71	0	0.641262248411017	0.6611328125	0.6279296875	2026-04-18 14:00:04.544446	3	0.004035673141479492	\N	\N	\N
146	100	2.180625	22.05	1.435	24928.61440677966	1459593.73	0	2.6489341998922415	2.669921875	2.564453125	2026-04-18 14:00:04.721309	1	1.3919770526885986	\N	\N	\N
378	100	1.8511016949152543	30.345	1.05	\N	\N	\N	2.0494157176906778	2.0791015625	1.87158203125	2026-04-21 17:00:05.163851	5	0.0019015682154688341	0.043751390132498236	0.06834457715352377	0.2750826517740885
442	100	4.7277966101694915	32.38	2.305	\N	\N	\N	3.8371457891949152	3.94384765625	3.7548828125	2026-04-22 17:00:01.575235	4	0.009699734025082346	0.25397080098168323	0.3068743546803792	3.767849334081014
443	100	1.1359482758620691	25.62	0.475	\N	\N	\N	2.7048255657327585	2.73583984375	2.6123046875	2026-04-22 17:00:01.990202	7	1.765267323639433e-05	0.06722219257031457	0.0817215919494629	8.178088188171387
444	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 17:00:02.62692	2	\N	\N	\N	\N
445	100	1.2596610169491527	2.44	1.11	\N	\N	\N	0.7999453787076272	0.818359375	0.78173828125	2026-04-22 17:00:02.849189	3	0.000950005418163235	0.05277705548173291	0.15062554677327475	0.22910343805948893
446	100	2.16390350877193	32.005	1.445	\N	\N	\N	2.7844445180084745	2.80810546875	2.7021484375	2026-04-22 17:00:03.189851	1	0.008860176377377267	0.1781104677814548	0.08466138839721679	0.38683552742004396
147	100	1.1751694915254236	3.59	0.84	16.475172413793103	955.56	0	2.61915717690678	2.64208984375	2.59716796875	2026-04-18 14:00:04.917697	6	0.0009112930297851562	\N	\N	\N
148	100	3.7457627118644066	12.725	2.215	10737.458474576271	553032.54	136.51	3.9442117981991527	3.98193359375	3.89208984375	2026-04-18 15:01:03.699746	4	0.5274129295349121	\N	\N	\N
149	100	1.1174137931034482	33.62	0.49	0	0	0	2.851806640625	2.8681640625	2.7587890625	2026-04-18 15:01:04.137561	7	0	\N	\N	\N
152	100	1.3415254237288137	1.775	1.195	6096.8810169491535	287222.34	0	0.6438857256355932	0.662109375	0.62060546875	2026-04-18 15:01:04.93697	3	0.27391656875610354	\N	\N	\N
153	100	2.2000892857142857	21.875	1.455	27863.64966101695	1471999.69	0	2.648387844279661	2.666015625	2.54931640625	2026-04-18 15:01:05.405333	1	1.4038082981109619	\N	\N	\N
154	100	0.9736440677966102	1.61	0.915	0	0	0	2.6163847325211864	2.62548828125	2.6064453125	2026-04-18 15:01:05.654487	6	0	\N	\N	\N
155	100	2.3630508474576275	3.605	2.225	10200.168135593221	544337.14	204.74	3.958438162076271	3.97509765625	3.935546875	2026-04-18 16:00:01.462933	4	0.5191203498840332	\N	\N	\N
156	100	1.1063559322033898	33.62	0.485	0	0	0	2.850768008474576	2.869140625	2.7548828125	2026-04-18 16:00:01.956773	7	0	\N	\N	\N
159	100	1.3833050847457626	2.56	1.21	13716.073220338983	783380.63	0	0.636768405720339	0.64990234375	0.5947265625	2026-04-18 16:00:03.172783	3	0.7470899868011475	\N	\N	\N
160	100	2.1739367816091955	21.25	1.475	13818.980169491526	758799.52	0	2.6508540783898304	2.669921875	2.57177734375	2026-04-18 16:00:03.555636	1	0.7236476135253906	\N	\N	\N
161	100	0.971271186440678	1.415	0.89	0	0	0	2.6238910222457625	2.66796875	2.6025390625	2026-04-18 16:00:03.869994	6	0	\N	\N	\N
162	100	2.3560169491525422	3.685	2.245	10443.014915254238	547128.6	204.74	3.957271252648305	3.97216796875	3.93212890625	2026-04-18 17:01:19.313787	4	0.5217824935913086	\N	\N	\N
163	100	1.1111864406779661	33.81	0.485	19.3415	1160.49	0	2.856197033898305	2.869140625	2.76953125	2026-04-18 17:01:19.649333	7	0.001106729507446289	\N	\N	\N
166	100	1.2519166666666666	1.75	1.13	548.3580000000001	16655.74	0	0.6529866536458333	0.6728515625	0.63427734375	2026-04-18 17:01:20.76746	3	0.015884151458740236	\N	\N	\N
167	100	2.1935454545454545	20.905	1.45	30107.19440677966	1294570.99	0	2.652237955729167	2.67041015625	2.56396484375	2026-04-18 17:01:21.093514	1	1.2345991039276123	\N	\N	\N
168	100	0.95925	1.66	0.825	0	0	0	2.647932942708333	2.67626953125	2.63671875	2026-04-18 17:01:21.431763	6	0	\N	\N	\N
169	100	2.403916666666667	3.665	2.235	10772.787166666667	529029.08	204.81	4.037255859375	4.0556640625	4.01123046875	2026-04-18 20:38:47.899851	4	0.5045214462280273	\N	\N	\N
170	100	1.1126271186440677	33.66	0.485	17.066	750.92	0	2.8307981329449152	2.84130859375	2.734375	2026-04-18 20:38:48.287611	7	0.0007161331176757812	\N	\N	\N
173	100	1.2014166666666666	1.655	1.125	53.47233333333334	2389.17	0	0.6439697265625	0.66455078125	0.62158203125	2026-04-18 20:38:49.315356	3	0.0022784900665283204	\N	\N	\N
174	100	2.5031515151515147	35.5	1.44	22166.361833333332	969492.73	0	2.653518935381356	2.66943359375	2.57666015625	2026-04-18 20:38:49.663552	1	0.9245803165435791	\N	\N	\N
175	100	1.0155833333333333	2.24	0.91	73.94366666666666	3890.55	0	2.6047037760416667	2.640625	2.59375	2026-04-18 20:38:49.990141	6	0.003710317611694336	\N	\N	\N
176	100	2.3987288135593223	3.51	2.245	10351.608983050848	525418.76	68.26	4.150249933792373	4.16552734375	4.13232421875	2026-04-19 09:00:02.822088	4	0.5010783767700195	\N	\N	\N
177	100	1.1143103448275862	23.145	0.48	18.510677966101696	1092.13	0	3.0452586206896552	3.0556640625	2.9638671875	2026-04-19 09:00:03.556942	7	0.001041536331176758	\N	\N	\N
179	100	1.1901694915254237	1.65	1.115	113.38796610169491	6553.39	0	0.9962840969279662	1.03173828125	0.97802734375	2026-04-19 09:00:04.634636	3	0.006249799728393555	\N	\N	\N
180	100	2.1895614035087716	24.645	1.43	9361.644576271186	524623.67	0	2.9983246901939653	3.01806640625	2.904296875	2026-04-19 09:00:05.055426	1	0.5003201198577881	\N	\N	\N
182	100	0.9589830508474576	1.57	0.885	0	0	0	2.6281200344279663	2.65234375	2.6103515625	2026-04-19 09:00:05.946185	6	0	\N	\N	\N
183	100	2.4125	3.87	2.21	9637.091186440679	528110.75	68.24	4.149745100635593	4.169921875	4.12890625	2026-04-19 10:00:01.211825	4	0.503645658493042	\N	\N	\N
184	100	1.1149137931034483	23.6	0.485	0	0	0	3.0179906384698274	3.03466796875	2.9326171875	2026-04-19 10:00:01.757026	7	0	\N	\N	\N
186	100	1.1800000000000002	1.63	1.105	45.118813559322035	2252.44	0	1.0066869703389831	1.03271484375	0.982421875	2026-04-19 10:00:02.55903	3	0.002148094177246094	\N	\N	\N
187	100	2.153377192982456	25.34	1.42	9342.908305084746	526930.65	0	2.9705127780720337	2.990234375	2.8779296875	2026-04-19 10:00:02.765961	1	0.502520227432251	\N	\N	\N
189	100	0.9651694915254238	1.53	0.84	0	0	0	2.611998477224576	2.6357421875	2.595703125	2026-04-19 10:00:03.321839	6	0	\N	\N	\N
190	100	2.357542372881356	3.825	2.22	10343.013559322035	526142.52	68.25	4.15038234904661	4.16650390625	4.12158203125	2026-04-19 11:00:01.756481	4	0.5017686080932617	\N	\N	\N
191	100	1.1126724137931037	24.19	0.485	127.26016949152542	3344.66	0	3.010851629849138	3.025390625	2.9228515625	2026-04-19 11:00:02.203493	7	0.003189716339111328	\N	\N	\N
193	100	1.1862711864406779	1.63	1.105	9.254915254237288	68.27	0	1.0068524894067796	1.0302734375	0.99169921875	2026-04-19 11:00:02.963414	3	6.510734558105468e-05	\N	\N	\N
194	100	2.139830508474576	25.685	1.41	9039.433050847458	524521.18	0	2.9549788135593222	2.96728515625	2.8720703125	2026-04-19 11:00:03.269352	1	0.5002223777770997	\N	\N	\N
196	100	0.9748305084745763	1.57	0.89	517.8662068965517	27783.69	0	2.6055846133474576	2.619140625	2.58447265625	2026-04-19 11:00:03.890898	6	0.026496591567993163	\N	\N	\N
197	100	2.362372881355932	3.54	2.22	9683.382881355932	526337.45	68.25	4.1542720471398304	4.1708984375	4.12939453125	2026-04-19 12:00:02.624755	4	0.5019545078277587	\N	\N	\N
198	100	1.1206034482758622	24.775	0.495	211.73457627118646	11809.75	0	3.0095046470905173	3.0244140625	2.91455078125	2026-04-19 12:00:02.913697	7	0.011262655258178711	\N	\N	\N
200	100	1.2029661016949151	1.705	1.13	180.47220338983053	5391.99	0	1.0036910752118644	1.03125	0.986328125	2026-04-19 12:00:03.67253	3	0.005142202377319336	\N	\N	\N
201	100	2.153793103448276	26.315	1.415	9207.386271186442	524123.31	0	2.946642645474138	2.9580078125	2.85888671875	2026-04-19 12:00:04.071601	1	0.49984293937683105	\N	\N	\N
203	100	0.9693220338983051	1.615	0.895	2.353793103448276	136.52	0	2.6067101430084745	2.619140625	2.59521484375	2026-04-19 12:00:04.897965	6	0.00013019561767578126	\N	\N	\N
204	100	2.36625	3.52	2.235	9543.169166666667	524673.09	136.51	4.155208333333333	4.171875	4.1337890625	2026-04-19 14:04:50.369478	4	0.5003672504425049	\N	\N	\N
205	100	1.1166949152542374	25.98	0.495	18.20133333333333	1092.08	0	2.985111559851695	3.0107421875	2.9150390625	2026-04-19 14:04:50.738948	7	0.0010414886474609374	\N	\N	\N
207	100	1.2336666666666667	1.76	1.125	6.825	68.26	0	1.0080729166666667	1.03271484375	0.984375	2026-04-19 14:04:51.262442	3	6.509780883789063e-05	\N	\N	\N
208	100	2.164051724137931	27.52	1.42	12104.2675	524534.44	0	2.9254964192708335	2.94189453125	2.83935546875	2026-04-19 14:04:51.448349	1	0.5002350234985351	\N	\N	\N
210	100	0.9760833333333333	1.61	0.82	0	0	0	2.6185709635416665	2.6455078125	2.5888671875	2026-04-19 14:04:52.129766	6	0	\N	\N	\N
211	100	2.376186440677966	3.905	2.22	9898.678644067797	525861.6	0	4.15282375529661	4.17138671875	4.12646484375	2026-04-19 15:00:01.317672	4	0.5015007019042969	\N	\N	\N
212	100	1.115689655172414	26.545	0.485	0	0	0	2.985393655711207	2.99609375	2.8935546875	2026-04-19 15:00:01.734794	7	0	\N	\N	\N
214	100	1.1993220338983053	1.66	1.125	32.39	1296.76	0	1.004493842690678	1.0244140625	0.9873046875	2026-04-19 15:00:02.684273	3	0.0012366867065429687	\N	\N	\N
379	100	3.043813559322034	12.715	2.24	\N	\N	\N	3.805117849576271	3.8388671875	3.779296875	2026-04-21 18:00:01.322654	4	0.009577765060683427	0.2447996105582027	0.15997379620869953	1.7912378787994385
380	100	1.0910344827586207	34.02	0.46	\N	\N	\N	2.8599558863146552	2.88330078125	2.72705078125	2026-04-21 18:00:01.724256	7	0.00010592040369066141	0.03491638135101836	0.0703320026397705	0.2333112398783366
381	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 18:00:02.12724	2	\N	\N	\N	\N
382	100	1.3033050847457626	1.705	1.18	\N	\N	\N	0.8591018935381356	0.8818359375	0.8408203125	2026-04-21 18:00:02.361382	3	3.971552444716631e-05	0.0488358156559831	0.0760018507639567	0.17988020579020184
383	100	2.11890350877193	30.395	1.43	\N	\N	\N	2.8393217941810347	2.857421875	2.65185546875	2026-04-21 18:00:02.813323	1	0.008582343570256636	0.18703278994156142	0.07562603950500488	0.3198745091756185
384	100	0.9194067796610169	1.435	0.805	\N	\N	\N	2.6085887844279663	2.62646484375	2.59912109375	2026-04-21 18:00:03.129599	6	0.00011448991709742054	0.03712357337014717	0.15103610356648764	0.3709824562072754
215	100	2.207255747126437	27.925	1.445	108779.10949152544	5879659.73	0	2.9131107653601696	2.927734375	2.7685546875	2026-04-19 15:00:03.07915	1	5.607280473709107	\N	\N	\N
217	100	0.9638983050847457	1.495	0.895	0	0	0	2.613910222457627	2.630859375	2.591796875	2026-04-19 15:00:03.858265	6	0	\N	\N	\N
218	100	2.3619491525423726	3.87	2.22	9507.592711864407	526749.91	68.25	4.162647311970339	4.17822265625	4.146484375	2026-04-19 16:00:02.490769	4	0.5023478603363037	\N	\N	\N
219	100	1.1060169491525422	26.99	0.49	0	0	0	2.980667372881356	2.99560546875	2.890625	2026-04-19 16:00:02.980516	7	0	\N	\N	\N
221	100	1.2243220338983052	2.625	1.11	404.8910169491525	18223.14	0	1.0063228283898304	1.03076171875	0.9814453125	2026-04-19 16:00:03.894871	3	0.01737894058227539	\N	\N	\N
222	100	2.1614406779661017	28.505	1.44	9137.594067796612	524033.01	0	2.896054025423729	2.91064453125	2.69189453125	2026-04-19 16:00:04.29377	1	0.4997568225860596	\N	\N	\N
224	100	0.9483898305084746	1.55	0.875	514.2101724137931	29824.19	0	2.613388837394068	2.62744140625	2.59375	2026-04-19 16:00:04.902884	6	0.028442564010620116	\N	\N	\N
225	100	2.3611666666666666	3.565	2.215	9442.211333333335	528717.31	0	4.159847005208333	4.173828125	4.14306640625	2026-04-19 17:01:11.980709	4	0.5042241191864014	\N	\N	\N
226	100	1.1095762711864408	27.62	0.485	0	0	0	2.9813625529661016	3.00927734375	2.73828125	2026-04-19 17:01:12.391817	7	0	\N	\N	\N
228	100	1.2234166666666666	1.71	1.12	81.90116666666667	4299.74	0	1.0136637369791666	1.04150390625	0.994140625	2026-04-19 17:01:12.970485	3	0.004100551605224609	\N	\N	\N
229	100	2.136779661016949	29.18	1.44	9374.046779661017	524125.51	0	2.892958818855932	2.90625	2.72998046875	2026-04-19 17:01:13.219186	1	0.49984503746032716	\N	\N	\N
231	100	0.9611666666666667	1.585	0.885	0	0	0	2.6061360677083334	2.61962890625	2.5927734375	2026-04-19 17:01:29.914464	6	0	\N	\N	\N
232	100	2.365677966101695	3.95	2.22	9709.193220338984	527040.84	68.25	4.161041777012712	4.18212890625	4.1435546875	2026-04-19 18:00:01.22826	4	0.5026253128051758	\N	\N	\N
233	100	1.1202586206896554	28.17	0.49	0	0	0	2.9797447467672415	3.00048828125	2.73681640625	2026-04-19 18:00:01.398851	7	0	\N	\N	\N
235	100	1.216864406779661	1.625	1.09	1695.8153448275862	96787.47	0	1.0095835540254237	1.033203125	0.994140625	2026-04-19 18:00:02.409185	3	0.09230372428894043	\N	\N	\N
236	100	1.8816379310344828	15.685	1.39	9169.025254237287	534897.2	0	2.88624702065678	2.8994140625	2.66650390625	2026-04-19 18:00:02.749702	1	0.5101177215576171	\N	\N	\N
238	100	0.9673728813559322	1.565	0.89	0	0	0	2.6052535752118646	2.6201171875	2.59375	2026-04-19 18:00:03.310832	6	0	\N	\N	\N
239	100	5.530847457627119	48.98	2.23	11959.578983050847	531287.03	136.5	3.923232256355932	3.953125	3.86083984375	2026-04-20 10:00:02.408745	4	0.5066747951507569	\N	\N	\N
240	100	1.101896551724138	22.99	0.475	8363.195084745763	491721.89	0	2.9597504714439653	3.01953125	2.83203125	2026-04-20 10:00:02.880678	7	0.46894253730773927	\N	\N	\N
242	100	1.6442372881355933	10.65	1.135	54238.11016949153	1932355.96	0	1.1100288003177967	1.1630859375	0.99755859375	2026-04-20 10:00:04.471879	3	1.842838249206543	\N	\N	\N
243	100	2.1765254237288136	31.85	1.355	60070.12457627118	2492264.85	0	2.9105783236228815	2.97119140625	2.69677734375	2026-04-20 10:00:04.852058	1	2.3768089771270753	\N	\N	\N
244	100	1.7958620689655171	28.405	0.875	47601.48881355932	1309184.19	0	2.2350569100215516	2.27490234375	2.1455078125	2026-04-20 10:00:05.29445	5	1.24853533744812	\N	\N	\N
245	100	0.906864406779661	2.6	0.805	3099.391724137931	174099.95	0	2.6059487552966103	2.62158203125	2.5810546875	2026-04-20 10:00:05.618878	6	0.16603465080261232	\N	\N	\N
246	100	4.215338983050848	9.12	2.22	14182.600847457628	635751.88	136.5	3.9425731594279663	4.0986328125	3.86767578125	2026-04-20 11:00:01.1835	4	0.6063002395629883	\N	\N	\N
247	100	1.1032758620689656	23.7	0.475	3817.6354237288137	222373.32	0	2.892333984375	2.9267578125	2.81396484375	2026-04-20 11:00:01.926572	7	0.2120717239379883	\N	\N	\N
249	100	1.3028813559322034	1.775	1.12	345.94525423728817	14949.67	0	0.9845074152542372	1.0029296875	0.96240234375	2026-04-20 11:00:02.488121	3	0.014257116317749024	\N	\N	\N
250	100	2.099342105263158	32.27	1.34	9033.13593220339	525446.31	0	2.874132879849138	2.88818359375	2.708984375	2026-04-20 11:00:02.688729	1	0.5011046504974366	\N	\N	\N
251	100	1.6563793103448277	26.86	0.86	6943.613898305085	313762.28	0	2.2195160964439653	2.2431640625	2.11962890625	2026-04-20 11:00:03.118799	5	0.29922702789306643	\N	\N	\N
252	100	0.8954237288135592	1.635	0.8	0	0	0	2.5956782971398304	2.62060546875	2.58447265625	2026-04-20 11:00:03.421272	6	0	\N	\N	\N
253	100	3.7263559322033895	10.62	2.255	10051.006440677966	530145.42	0	3.8984623278601696	3.9443359375	3.86376953125	2026-04-20 12:07:19.528302	4	0.5055860710144043	\N	\N	\N
254	100	1.096637931034483	24.3	0.47	133.05457627118645	6553.25	0	2.8761701912715516	2.8974609375	2.81298828125	2026-04-20 12:07:20.571515	7	0.006249666213989258	\N	\N	\N
256	100	1.186949152542373	1.65	1.08	121.47338983050848	3071.3	0	0.9882067664194916	1.0078125	0.96728515625	2026-04-20 12:07:21.320608	3	0.002929019927978516	\N	\N	\N
257	100	2.0935964912280705	32.905	1.315	9072.8206779661	525125.32	0	2.8596315545550848	2.87646484375	2.64892578125	2026-04-20 12:07:21.690742	1	0.5007985305786132	\N	\N	\N
258	100	1.3907758620689656	25.94	0.855	924.9078333333333	20954.73	0	2.2234812769396552	2.24267578125	2.212890625	2026-04-20 12:07:22.065529	5	0.01998398780822754	\N	\N	\N
259	100	0.8749166666666667	1.5	0.8	4.550833333333333	273.05	0	2.6058756510416665	2.63232421875	2.59521484375	2026-04-20 12:07:22.336509	6	0.0002604007720947266	\N	\N	\N
260	100	5.021249999999999	26.14	2.26	9953.593833333334	529913.01	68.25	3.928238932291667	4.1123046875	3.86865234375	2026-04-20 14:30:44.553469	4	0.5053644275665283	\N	\N	\N
261	100	1.0801694915254239	25.19	0.47	0	0	0	2.8927022643008473	2.908203125	2.81884765625	2026-04-20 14:30:45.584031	7	0	\N	\N	\N
263	100	1.7154166666666666	16.55	1.115	5585.8135	234331.52	0	0.9584635416666667	0.974609375	0.93896484375	2026-04-20 14:30:48.666645	3	0.2234759521484375	\N	\N	\N
264	100	2.188684210526316	33.94	1.4	13295.795833333335	525654.64	0	2.7982503255208333	2.82080078125	2.6025390625	2026-04-20 14:30:50.046761	1	0.5013033294677735	\N	\N	\N
265	100	0.8778333333333334	1.445	0.785	0	0	0	2.638313802083333	2.6650390625	2.623046875	2026-04-20 14:30:50.761052	6	0	\N	\N	\N
266	100	1.6294166666666667	25.13	0.845	604.1181666666666	35905.81	0	2.1814778645833335	2.21142578125	2.09130859375	2026-04-20 14:30:52.566876	5	0.03424244880676269	\N	\N	\N
267	100	4.076610169491525	35.25	2.26	10146.676101694913	529986.58	136.5	3.9145590572033897	3.94677734375	3.8857421875	2026-04-20 15:00:00.758379	4	0.5054345893859863	\N	\N	\N
268	100	1.092155172413793	25.77	0.465	24.297627118644066	1433.56	0	2.8861799568965516	2.8994140625	2.810546875	2026-04-20 15:00:01.079106	7	0.0013671493530273437	\N	\N	\N
270	100	1.2184745762711864	1.71	1.135	17612.196779661015	778917.29	0	0.9600436970338984	0.9853515625	0.93896484375	2026-04-20 15:00:01.678137	3	0.7428334140777588	\N	\N	\N
271	100	2.174642857142857	34.575	1.375	12823.40033898305	525986.48	0	2.785425646551724	2.81298828125	2.62451171875	2026-04-20 15:00:02.209194	1	0.5016197967529297	\N	\N	\N
272	100	0.886186440677966	1.28	0.785	0	0	0	2.632216631355932	2.66455078125	2.623046875	2026-04-20 15:00:02.60703	6	0	\N	\N	\N
273	100	1.640603448275862	25.13	0.85	612.0435593220338	35905.81	0	2.1741901266163794	2.201171875	2.09130859375	2026-04-20 15:00:03.058034	5	0.03424244880676269	\N	\N	\N
274	100	3.7134745762711865	12.555	2.245	55202.9020338983	2378074.34	68.24	3.9050830905720337	4.00390625	3.802734375	2026-04-20 16:37:09.42429	4	2.267908420562744	\N	\N	\N
275	100	1.0915254237288134	26.955	0.48	6.825166666666666	409.51	0	2.8825145656779663	2.90185546875	2.7978515625	2026-04-20 16:37:10.203875	7	0.00039053916931152343	\N	\N	\N
367	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 16:13:23.88285	2	\N	\N	\N	\N
385	100	1.8489830508474576	30.915	1.055	\N	\N	\N	2.051128840042373	2.08251953125	1.89306640625	2026-04-21 18:00:05.529055	5	0.0018093592545081832	0.04654414298686575	0.069732666015625	0.27586520512898766
447	100	1.7995762711864407	14.72	0.765	\N	\N	\N	2.617874404131356	2.65380859375	2.4072265625	2026-04-22 17:00:03.678641	6	4.3769704884496225e-05	0.03799847158892401	8.366705560684204	0.2593085765838623
448	100	1.9031355932203389	38.235	0.92	\N	\N	\N	2.1353532176906778	2.158203125	2.0517578125	2026-04-22 17:00:04.138052	5	0.0029069795279667294	0.04495843246065337	0.371069065729777	0.2832301616668701
561	100	3.002627118644068	12.305	2.325	\N	\N	\N	3.7508772510593222	3.76708984375	3.72314453125	2026-04-24 16:00:01.581098	4	0.010437087527776168	0.24680525666576322	0.13574512799580893	1.3183842341105143
562	100	1.1468103448275861	30.43	0.465	\N	\N	\N	2.779987203663793	2.81396484375	2.64013671875	2026-04-24 16:00:02.534231	7	0.074947773723279	0.07393302707348841	0.15352754592895507	0.235522190729777
370	100	0.9289830508474577	1.54	0.785	\N	\N	\N	2.6348814883474576	2.6552734375	2.60888671875	2026-04-21 16:13:25.139611	6	0	0.03691372467299639	0.17448585828145344	0.25859233538309734
365	100	2.4718333333333335	5.73	2.265	\N	\N	\N	3.8065511067708333	3.8232421875	3.783203125	2026-04-21 16:13:22.94648	4	0.010015487670898438	0.23639146041870118	0.12592105865478515	0.9174800554911295
366	100	1.0872033898305087	34.03	0.465	\N	\N	\N	2.859772245762712	2.89599609375	2.74365234375	2026-04-21 16:13:23.418598	7	0.0035676956176757812	0.027995638688405357	0.07518877983093261	0.26056437492370604
368	100	1.3048333333333335	2.42	1.145	\N	\N	\N	0.8445556640625	0.87109375	0.81787109375	2026-04-21 16:13:24.293208	3	0.0023794174194335938	0.06758396482467652	0.08018765449523926	0.1818993091583252
369	100	2.1071666666666666	29.02	1.405	\N	\N	\N	2.8557373046875	2.8671875	2.7021484375	2026-04-21 16:13:24.699847	1	0.008821487426757812	0.17762689431508383	0.08004951477050781	0.32137881914774574
371	100	1.8556666666666668	30.345	1.08	\N	\N	\N	2.0499674479166665	2.080078125	1.87158203125	2026-04-21 16:13:25.528221	5	0.0017099380493164062	0.045773304899533594	0.07413811683654785	0.27785491943359375
277	100	2.6833898305084745	44.795	1.07	17477.913898305083	384305.3	0	0.6373146186440678	0.6650390625	0.6181640625	2026-04-20 16:37:10.823239	3	0.3665020942687988	\N	\N	\N
278	100	2.253660714285714	35.825	1.38	12508.4593220339	525367.41	0	2.7577131885593222	2.77294921875	2.58349609375	2026-04-20 16:37:11.158207	1	0.5010294055938721	\N	\N	\N
279	100	0.8743220338983051	1.47	0.8	1.1567796610169492	68.25	0	2.6324980137711864	2.66015625	2.615234375	2026-04-20 16:37:11.449431	6	6.508827209472656e-05	\N	\N	\N
280	100	1.6392241379310346	22.945	0.855	1244.8144067796609	45871.35	0	2.1618776483050848	2.18798828125	2.08447265625	2026-04-20 16:37:11.646694	5	0.043746328353881835	\N	\N	\N
281	100	3.695847457627119	12.555	2.245	10614.209830508475	531150.01	68.24	3.8507100768008473	4.00390625	3.77099609375	2026-04-20 17:00:03.224712	4	0.5065441226959229	\N	\N	\N
282	100	1.0959482758620689	26.955	0.47	0	0	0	2.8767594962284484	2.89453125	2.7978515625	2026-04-20 17:00:03.739223	7	0	\N	\N	\N
284	100	1.2964406779661015	1.865	1.07	4020.3179661016948	186824.61	0	0.6357421875	0.65283203125	0.62109375	2026-04-20 17:00:04.241296	3	0.17816983222961424	\N	\N	\N
285	100	2.1473214285714284	35.825	1.38	9553.938305084746	527231.44	0	2.7588221663135593	2.77294921875	2.58349609375	2026-04-20 17:00:04.467258	1	0.5028070831298828	\N	\N	\N
286	100	0.8846610169491526	2.415	0.795	0	0	0	2.6198192531779663	2.6337890625	2.611328125	2026-04-20 17:00:04.788374	6	0	\N	\N	\N
287	100	1.638103448275862	22.945	0.86	786.735593220339	45871.35	0	2.1608129040948274	2.18798828125	2.08447265625	2026-04-20 17:00:05.371174	5	0.043746328353881835	\N	\N	\N
288	100	2.3646666666666665	3.855	2.22	10388.669833333332	529943.12	68.25	3.7923990885416665	3.8076171875	3.7734375	2026-04-20 19:00:28.229882	4	0.5053931427001953	\N	\N	\N
289	100	1.0790677966101694	28.015	0.47	29.576166666666666	1774.57	0	2.8685364804025424	2.88671875	2.642578125	2026-04-20 19:00:28.591378	7	0.001692361831665039	\N	\N	\N
291	100	1.3506666666666667	2.195	1.165	5740.773499999999	307723.76	0	0.6299153645833333	0.6748046875	0.6103515625	2026-04-20 19:00:29.072313	3	0.29346824645996095	\N	\N	\N
292	100	2.107627118644068	26.54	1.4	8947.436	525515.29	0	2.738671875	2.765625	2.6298828125	2026-04-20 19:00:29.409683	1	0.5011704349517823	\N	\N	\N
293	100	0.94	1.39	0.78	0	0	0	2.6045247395833333	2.62939453125	2.5830078125	2026-04-20 19:00:29.662434	6	0	\N	\N	\N
294	96.96969696969697	2.1347058823529412	21.955	0.855	1698.031212121212	55898.54	0	2.128151633522727	2.154296875	2.04931640625	2026-04-20 19:00:29.983164	5	0.05330900192260742	\N	\N	\N
295	100	2.649406779661017	8.675	2.27	11753.16593220339	533360.64	68.25	3.9831832627118646	4.01318359375	3.8759765625	2026-04-21 08:00:02.314217	4	0.50865234375	\N	\N	\N
296	98.33333333333333	1.5138793103448274	40.175	0.475	236301.34694915256	11078821.69	0	2.9355552936422415	3.1513671875	2.8056640625	2026-04-21 08:00:03.650016	7	10.565587701797485	\N	\N	\N
298	100	1.4156666666666666	8.23	1.1	99863.21576271187	5839573.3	0	0.7822596663135594	0.8603515625	0.7255859375	2026-04-21 08:00:04.396134	3	5.569051074981689	\N	\N	\N
299	96.66666666666667	2.5445614035087716	33.1	1.325	434578.153220339	12560420	0	2.8426492981991527	3.3212890625	2.666015625	2026-04-21 08:00:04.924742	1	11.97854995727539	\N	\N	\N
300	100	0.9999152542372881	8.565	0.82	58020.68172413793	3365063.05	0	2.604930813029661	2.625	2.57568359375	2026-04-21 08:00:05.206972	6	3.2091742038726805	\N	\N	\N
301	98.14814814814815	4.012962962962963	79.84	1.02	401181.32264150947	15825063.17	0	2.236933955439815	2.2958984375	1.15673828125	2026-04-21 08:00:05.386772	5	15.091956300735474	\N	\N	\N
302	100	2.6733898305084742	7.36	2.395	11400.691694915253	349758.87	204.77	3.90576171875	3.9609375	3.82080078125	2026-04-21 10:00:04.609116	4	0.33355605125427246	\N	\N	\N
303	100	1.1003448275862069	32.725	0.475	0	0	0	2.9197366648706895	2.9375	2.76806640625	2026-04-21 10:00:05.240642	7	0	\N	\N	\N
305	100	1.301271186440678	1.795	1.135	38.177796610169494	1092.17	0	0.8417720471398306	0.86181640625	0.82275390625	2026-04-21 10:00:06.11674	3	0.0010415744781494141	\N	\N	\N
306	100	1.9295535714285716	13.525	1.395	9107.643	525367.49	0	2.9686068830818964	2.98291015625	2.8828125	2026-04-21 10:00:06.514916	1	0.5010294818878174	\N	\N	\N
307	100	0.867457627118644	1.485	0.81	0	0	0	2.615035752118644	2.6328125	2.60546875	2026-04-21 10:00:07.017376	6	0	\N	\N	\N
308	100	1.8727118644067795	24.94	1.06	1871.0418965517242	70295.71	0	2.2136106329449152	2.2353515625	2.1484375	2026-04-21 10:00:07.611934	5	0.067039213180542	\N	\N	\N
309	100	2.7355084745762714	5.085	2.29	10159.93627118644	532474.48	136.51	3.8661778336864407	3.912109375	3.81787109375	2026-04-21 11:00:02.859261	4	0.5078072357177734	\N	\N	\N
310	100	1.098103448275862	33.315	0.48	1261.0589830508475	37202.56	0	2.9062415813577585	2.94384765625	2.703125	2026-04-21 11:00:03.453741	7	0.0354791259765625	\N	\N	\N
312	100	1.5447457627118644	2.395	1.145	13485.16220338983	381754.17	0	0.8263291181144068	0.84716796875	0.7998046875	2026-04-21 11:00:04.223221	3	0.36406914710998534	\N	\N	\N
313	100	2.2331250000000002	26.11	1.415	37411.12305084746	1630859.01	0	2.9421924655720337	2.96826171875	2.8564453125	2026-04-21 11:00:04.544122	1	1.5553083515167236	\N	\N	\N
314	100	0.8864406779661016	1.91	0.79	38.8351724137931	2252.44	0	2.6234523967161016	2.6689453125	2.60400390625	2026-04-21 11:00:04.911448	6	0.002148094177246094	\N	\N	\N
315	100	1.878728813559322	25.605	1.06	1543.1363793103449	76601.85	0	2.1825344279661016	2.2216796875	2.12841796875	2026-04-21 11:00:05.162457	5	0.07305321693420411	\N	\N	\N
316	100	2.931186440677966	14.75	2.275	9883.099661016948	532795.69	204.8	3.8122682733050848	3.85107421875	3.734375	2026-04-21 12:00:03.033716	4	0.5081135654449462	\N	\N	\N
317	100	1.0845689655172415	33.88	0.455	254.54406779661016	14540.29	0	2.8907681169181036	2.92041015625	2.6787109375	2026-04-21 12:00:03.364683	7	0.013866701126098634	\N	\N	\N
319	100	1.4396610169491526	2.175	1.2	385.2396610169491	14811.23	0	0.8118958554025424	0.83056640625	0.7978515625	2026-04-21 12:00:04.436266	3	0.014125089645385742	\N	\N	\N
563	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 16:00:02.948863	2	\N	\N	\N	\N
564	100	3.199322033898305	27.1	1.165	\N	\N	\N	0.5375811043432204	0.56298828125	0.52001953125	2026-04-24 16:00:03.27513	3	0.02450057967234466	0.17203679262581517	1.1060727914174397	0.604244597752889
565	100	2.305789473684211	25.105	1.44	\N	\N	\N	2.739655058262712	2.75732421875	2.65283203125	2026-04-24 16:00:03.655304	1	0.030886522390074646	0.20979620206154	0.42047026952107747	1.2540155887603759
566	100	0.9688983050847457	1.52	0.815	\N	\N	\N	2.6046494306144066	2.62158203125	2.59228515625	2026-04-24 16:00:04.146958	6	0	0.03641218645819302	0.1665572166442871	0.26171050071716306
567	100	1.6355084745762714	35.95	0.855	\N	\N	\N	2.1025473384533897	2.134765625	1.95458984375	2026-04-24 16:00:04.373955	5	0.00494906927409925	0.046428841038754116	0.07092123031616211	0.28631776173909507
603	100	2.4177966101694914	4.035	2.275	\N	\N	\N	3.9539112155720337	3.97265625	3.92431640625	2026-04-24 22:00:01.570433	4	0.009513665538723185	0.24672726485688806	0.10352161725362143	0.4626586119333903
604	100	1.1103448275862067	34.11	0.49	\N	\N	\N	2.852337015086207	2.869140625	2.70166015625	2026-04-24 22:00:02.209679	7	9.93082078836732e-06	0.028111401897365766	0.0705598513285319	0.2352558453877767
6	100	0.9985833333333333	1.9	0.815	74.04847457627118	4368.86	0	2.5784261067708334	2.59130859375	2.5673828125	2026-03-31 16:49:41.133498	6	0.004166469573974609	\N	\N	\N
7	100	1.0699999999999998	18.635	0.465	27.768983050847456	1638.37	0	2.8435265492584745	2.86181640625	2.7607421875	2026-03-31 16:49:41.353467	7	0.0015624713897705077	\N	\N	\N
8	100	2.117083333333333	19.47	1.45	9211.128166666667	526254.23	0	2.8568603515625	2.87255859375	2.77587890625	2026-03-31 16:50:54.676307	1	0.5018751430511474	\N	\N	\N
10	100	1.3383050847457627	1.66	1.18	1409.4405000000002	23411.29	0	0.8413506869612069	0.8779296875	0.81884765625	2026-03-31 16:50:55.317114	3	0.022326745986938477	\N	\N	\N
11	100	2.4160999999999997	7.265	2.155	9647.255333333334	524572.42	0	4.044490559895833	4.064453125	4.02099609375	2026-03-31 16:50:55.611221	4	0.5002712440490723	\N	\N	\N
12	100	1.7	40.65	0.89	2104.494745762712	102529.31	0	2.128796807650862	2.154296875	2.0361328125	2026-03-31 16:50:55.902767	5	0.09777956962585449	\N	\N	\N
13	100	0.9995833333333334	1.9	0.815	74.04847457627118	4368.86	0	2.5784342447916666	2.59130859375	2.5673828125	2026-03-31 16:50:56.125754	6	0.004166469573974609	\N	\N	\N
14	100	1.0701694915254238	18.635	0.465	27.768983050847456	1638.37	0	2.843551377118644	2.86181640625	2.7607421875	2026-03-31 16:50:56.371695	7	0.0015624713897705077	\N	\N	\N
15	100	2.1158333333333332	19.47	1.45	9217.955500000002	526254.23	0	2.8555338541666666	2.87255859375	2.77587890625	2026-03-31 16:55:20.00263	1	0.5018751430511474	\N	\N	\N
17	100	1.336186440677966	1.66	1.18	79.63233333333332	3958.91	0	0.8423609240301724	0.8779296875	0.81884765625	2026-03-31 16:55:20.573128	3	0.003775510787963867	\N	\N	\N
18	100	2.4040566037735847	7.265	2.155	9625.6425	524572.42	0	4.044791666666667	4.064453125	4.02099609375	2026-03-31 16:55:20.972059	4	0.5002712440490723	\N	\N	\N
19	100	1.7121052631578948	40.65	0.895	1833.800847457627	102529.31	0	2.1282580145474137	2.154296875	2.0361328125	2026-03-31 16:55:21.269264	5	0.09777956962585449	\N	\N	\N
20	100	1.0010000000000001	1.9	0.815	74.04847457627118	4368.86	0	2.5784261067708334	2.59130859375	2.568359375	2026-03-31 16:55:21.701865	6	0.004166469573974609	\N	\N	\N
21	100	1.0704237288135594	18.635	0.465	27.768983050847456	1638.37	0	2.8438493114406778	2.86181640625	2.7607421875	2026-03-31 16:55:22.040296	7	0.0015624713897705077	\N	\N	\N
22	100	2.1264406779661016	19.47	1.45	9375.348813559323	526254.23	0	2.854144597457627	2.86865234375	2.77587890625	2026-03-31 17:01:11.095928	1	0.5018751430511474	\N	\N	\N
24	100	1.3405172413793103	1.66	1.18	77.51152542372881	3958.91	0	0.8424736156798246	0.8779296875	0.822265625	2026-03-31 17:01:11.812741	3	0.003775510787963867	\N	\N	\N
25	100	2.3954326923076925	7.265	2.155	9769.123898305086	524572.42	0	4.045087394067797	4.064453125	4.02734375	2026-03-31 17:01:12.026763	4	0.5002712440490723	\N	\N	\N
26	100	1.719642857142857	40.65	0.895	1913.6684482758621	102529.31	0	2.126781798245614	2.154296875	2.0361328125	2026-03-31 17:01:12.233609	5	0.09777956962585449	\N	\N	\N
27	100	0.9986440677966102	1.9	0.815	0	0	0	2.5783567266949152	2.59130859375	2.568359375	2026-03-31 17:01:12.424325	6	0	\N	\N	\N
28	100	1.0722881355932203	18.635	0.465	27.768983050847456	1638.37	0	2.844329316737288	2.86181640625	2.7607421875	2026-03-31 17:01:12.821039	7	0.0015624713897705077	\N	\N	\N
29	100	2.1153333333333335	19.47	1.455	9216.816833333334	526254.23	0	2.8533203125	2.86767578125	2.77587890625	2026-03-31 17:05:13.176161	1	0.5018751430511474	\N	\N	\N
31	100	1.3508474576271188	1.715	1.18	1776.877627118644	100330.86	0	0.8421909265350878	0.8779296875	0.822265625	2026-03-31 17:05:13.784582	3	0.09568296432495117	\N	\N	\N
32	100	2.4187264150943397	7.265	2.155	9704.33406779661	524572.42	0	4.043701171875	4.064453125	4.0166015625	2026-03-31 17:05:14.099207	4	0.5002712440490723	\N	\N	\N
33	100	1.7360714285714285	40.65	0.895	1881.2333898305085	102529.31	0	2.126178609913793	2.154296875	2.0361328125	2026-03-31 17:05:14.461081	5	0.09777956962585449	\N	\N	\N
34	100	1.0048305084745761	1.9	0.815	0	0	0	2.5780505164194913	2.59130859375	2.5673828125	2026-03-31 17:05:14.758977	6	0	\N	\N	\N
35	100	1.073135593220339	18.635	0.465	28.247758620689652	1638.37	0	2.8443393049568964	2.86181640625	2.7607421875	2026-03-31 17:05:14.95199	7	0.0015624713897705077	\N	\N	\N
37	100	5.357457627118643	45.34	1.135	3647.308135593221	196830.38	0	0.9291247351694916	0.9501953125	0.9130859375	2026-04-15 17:00:02.973052	3	0.18771207809448243	\N	\N	\N
38	100	1.7265517241379311	28.125	0.86	2769.858474576271	160554.02	0	2.1502054148706895	2.17626953125	2.0673828125	2026-04-15 17:00:03.289798	5	0.15311624526977538	\N	\N	\N
39	100	0.8416101694915255	1.475	0.775	0	0	0	2.646575410487288	2.6669921875	2.634765625	2026-04-15 17:00:03.668861	6	0	\N	\N	\N
40	100	1.0822413793103447	28.27	0.465	0	0	0	2.7979104929956895	2.80859375	2.5693359375	2026-04-15 17:00:04.005602	7	0	\N	\N	\N
41	100	2.288409090909091	22.61	1.425	31233.643559322034	1445097.13	0	2.7483199814618646	2.7607421875	2.673828125	2026-04-15 17:00:04.186385	1	1.3781520175933837	\N	\N	\N
42	100	2.9073728813559323	12.235	2.23	10796.167457627118	535200.21	68.27	4.028543763241525	4.04443359375	4.00537109375	2026-04-15 17:00:04.528993	4	0.5104066944122314	\N	\N	\N
43	100	1.2660169491525421	1.69	1.175	121.45898305084745	6074	0	0.9148818193855932	0.9521484375	0.8896484375	2026-04-15 19:00:01.461843	3	0.0057926177978515625	\N	\N	\N
44	100	2.832033898305085	14.48	2.2	9817.329152542374	526525.91	136.49	4.013994637182203	4.0419921875	3.9921875	2026-04-15 19:00:01.939741	4	0.5021342372894287	\N	\N	\N
45	96.96969696969697	2.29640625	26.77	0.895	5503.66	173727.99	0	2.1202392578125	2.14697265625	2.03369140625	2026-04-15 19:00:02.27257	5	0.16567992210388183	\N	\N	\N
46	100	0.8479661016949153	1.46	0.77	0	0	0	2.6280538268008473	2.65869140625	2.61181640625	2026-04-15 19:00:02.531776	6	0	\N	\N	\N
48	100	1.0710344827586207	29.355	0.455	1.156949152542373	68.26	0	2.7924299568965516	2.81201171875	2.638671875	2026-04-15 19:00:03.065006	7	6.509780883789063e-05	\N	\N	\N
49	100	2.189245283018868	21.22	1.415	25024.382881355934	1431452.4	0	2.721435546875	2.740234375	2.64794921875	2026-04-15 19:00:03.331235	1	1.3651393890380858	\N	\N	\N
50	100	1.7417796610169491	9.44	1.2	22951.892711864406	978428.34	0	1.0279809984110169	1.0703125	0.96923828125	2026-04-16 11:00:02.037843	3	0.9331019783020019	\N	\N	\N
51	100	2.431694915254237	5.18	2.22	10288.694406779661	545938.44	136.52	3.990052304025424	4.0126953125	3.966796875	2026-04-16 11:00:03.103658	4	0.5206474685668945	\N	\N	\N
52	100	1.8486440677966103	32.52	1.02	3276.3805172413795	189279.25	0	2.1660901085805087	2.19140625	2.0009765625	2026-04-16 11:00:03.270862	5	0.1805107593536377	\N	\N	\N
53	100	0.8844915254237289	1.63	0.825	0	0	0	2.5995348914194913	2.62353515625	2.59228515625	2026-04-16 11:00:03.45315	6	0	\N	\N	\N
54	100	1.0854310344827587	30.255	0.45	266.12949152542376	14541.19	0	3.007189520474138	3.02099609375	2.86181640625	2026-04-16 11:00:03.627846	7	0.013867559432983399	\N	\N	\N
56	100	2.319642857142857	36.585	1.43	146531.43169491523	5897390.06	0	2.8490217823093222	2.884765625	2.73291015625	2026-04-16 11:00:04.308271	1	5.624189434051513	\N	\N	\N
57	100	1.488220338983051	4.055	1.115	1232.4042372881356	53941.87	0	0.9835391287076272	0.9990234375	0.96875	2026-04-16 12:00:02.236017	3	0.05144297599792481	\N	\N	\N
58	100	2.558220338983051	9.675	2.205	9708.111016949153	524655.65	68.25	3.9947530455508473	4.0126953125	3.98046875	2026-04-16 12:00:02.543404	4	0.5003506183624268	\N	\N	\N
59	100	1.8191525423728814	33.43	1	3455.075344827586	200053.06	0	2.1457726430084745	2.1875	1.986328125	2026-04-16 12:00:02.863038	5	0.1907854652404785	\N	\N	\N
60	100	0.8949152542372881	1.5	0.79	0	0	0	2.598285222457627	2.6083984375	2.5888671875	2026-04-16 12:00:03.17332	6	0	\N	\N	\N
61	100	1.0699137931034484	30.82	0.455	0	0	0	3.0001010237068964	3.0126953125	2.79638671875	2026-04-16 12:00:03.47886	7	0	\N	\N	\N
63	100	2.2052678571428572	36.475	1.465	12931.13593220339	533782.41	0	2.813335871292373	2.83740234375	2.720703125	2026-04-16 12:00:04.139745	1	0.5090545749664307	\N	\N	\N
64	100	3.908135593220339	41.925	1.125	50919.90440677966	1143713.27	0	0.907764499470339	0.9912109375	0.86669921875	2026-04-16 13:00:01.209321	3	1.0907299709320069	\N	\N	\N
65	100	2.370084745762712	3.52	2.2	800.5916949152542	3891.01	136.51	3.9876357256355934	4.00634765625	3.97509765625	2026-04-16 13:00:01.553905	4	0.003710756301879883	\N	\N	\N
66	100	0.8876271186440677	1.395	0.775	0	0	0	2.610061904131356	2.62939453125	2.5986328125	2026-04-16 13:00:01.833173	6	0	\N	\N	\N
67	100	1.0769827586206895	31.45	0.455	1199.597288135593	69274.68	0	2.9966157058189653	3.0107421875	2.7724609375	2026-04-16 13:00:02.143312	7	0.06606548309326171	\N	\N	\N
276	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-20 16:37:10.424824	2	\N	\N	\N	\N
1	100	2.1175	19.47	1.45	9211.128166666667	526254.23	0	2.8570963541666665	2.87255859375	2.77587890625	2026-03-31 16:49:39.254991	1	0.5018751430511474	\N	\N	\N
3	100	1.3380508474576271	1.66	1.18	1409.4405000000002	23411.29	0	0.8411654768318966	0.8779296875	0.81884765625	2026-03-31 16:49:40.217421	3	0.022326745986938477	\N	\N	\N
4	100	2.4167	7.265	2.155	9647.254833333336	524572.42	0	4.044449869791666	4.064453125	4.02099609375	2026-03-31 16:49:40.556568	4	0.5002712440490723	\N	\N	\N
5	100	1.6994827586206895	40.65	0.89	2104.494745762712	102529.31	0	2.1288473195043105	2.154296875	2.0361328125	2026-03-31 16:49:40.793339	5	0.09777956962585449	\N	\N	\N
2	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-31 16:49:39.596969	2	\N	\N	\N	\N
386	100	4.103050847457627	43.2	2.235	\N	\N	\N	3.8161993511652543	3.87158203125	3.7705078125	2026-04-21 19:00:02.34299	4	0.00993223594406904	0.24518113815178305	0.16630180676778158	2.0776671091715495
387	100	1.1032758620689653	34.11	0.47	\N	\N	\N	2.8564621497844827	2.87548828125	2.7412109375	2026-04-21 19:00:03.766413	7	1.213704125355866e-05	0.027215684632123528	0.0703599770863851	0.23343510627746583
388	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 19:00:04.618106	2	\N	\N	\N	\N
9	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-31 16:50:55.007196	2	\N	\N	\N	\N
389	100	1.2496610169491527	1.62	1.15	\N	\N	\N	0.856105998411017	0.87646484375	0.841796875	2026-04-21 19:00:05.156627	3	3.5303083516783635e-05	0.04960305019960565	0.07696015040079753	0.1799011707305908
390	100	2.1265625	31.06	1.415	\N	\N	\N	2.8275609509698274	2.84130859375	2.65576171875	2026-04-21 19:00:05.70969	1	0.008613462124840689	0.17530074410519356	0.07390011151631673	0.3187069574991862
391	100	0.910593220338983	1.48	0.78	\N	\N	\N	2.595504502118644	2.60546875	2.5859375	2026-04-21 19:00:06.163305	6	0	0.03521589246289483	0.14584253629048666	0.31404587427775066
392	96.96969696969697	2.404375	31.44	1.065	\N	\N	\N	2.0454559326171875	2.0673828125	1.888671875	2026-04-21 19:00:06.607612	5	0.003423624932765961	0.05094238629707923	0.07034224271774292	0.40562766790390015
393	100	3.3703333333333334	8.63	2.295	\N	\N	\N	3.8404215494791667	3.86962890625	3.814453125	2026-04-22 10:05:31.282374	4	0.010057199796040852	0.2529158452351888	0.15526415506998698	1.8066742261250814
394	100	1.0799152542372883	21.49	0.46	\N	\N	\N	2.7455392611228815	2.77001953125	2.66259765625	2026-04-22 10:05:35.40565	7	0.00022240289052327474	0.02791575304667155	0.07078498204549154	0.23363558451334634
16	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-31 16:55:20.301957	2	\N	\N	\N	\N
395	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 10:05:37.127751	2	\N	\N	\N	\N
396	100	1.3123333333333334	1.71	1.17	\N	\N	\N	0.8117106119791667	0.83447265625	0.79833984375	2026-04-22 10:05:40.082659	3	8.461952209472657e-05	0.05063866519927978	0.08005118370056152	0.21041762034098307
397	100	2.239350282485876	27.855	1.365	\N	\N	\N	2.919417317708333	2.9365234375	2.828125	2026-04-22 10:05:42.821893	1	0.08679316218694051	0.2831312108039856	0.27099180221557617	0.32037375768025717
398	100	0.9208333333333333	1.565	0.805	\N	\N	\N	2.6200439453125	2.638671875	2.6015625	2026-04-22 10:05:45.459943	6	0.0018441328509100554	0.03806719944394868	0.14153181711832682	0.24233175913492838
399	100	1.7215833333333335	42.51	0.915	\N	\N	\N	2.2455078125	2.2744140625	2.1591796875	2026-04-22 10:05:47.769702	5	0.0023819771459547144	0.041779758135477706	0.07020750045776367	0.2773561477661133
449	100	4.997203389830508	17.635	2.325	\N	\N	\N	3.79833984375	3.84033203125	3.73095703125	2026-04-22 18:00:01.775182	4	0.011410611039501126	0.2704556819139901	0.3374189376831055	4.022870858510335
23	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-31 17:01:11.438556	2	\N	\N	\N	\N
450	100	1.094051724137931	26.025	0.465	\N	\N	\N	2.6930815598060347	2.7119140625	2.60791015625	2026-04-22 18:00:03.413055	7	6.398427284370035e-05	0.03501573126194841	0.070473051071167	0.23353241284688314
451	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 18:00:03.857795	2	\N	\N	\N	\N
452	100	1.325677966101695	6.285	1.135	\N	\N	\N	0.8177469544491526	0.8427734375	0.7861328125	2026-04-22 18:00:04.314306	3	0.02982753365726794	0.09344857991751977	0.870242182413737	0.18958896001180012
453	100	2.142276785714286	31.415	1.375	\N	\N	\N	2.7616194385593222	2.80126953125	2.69677734375	2026-04-22 18:00:04.755983	1	0.008638358358609476	0.18421824697720804	0.07913514773050943	0.3279212156931559
454	100	0.9555932203389831	1.63	0.805	\N	\N	\N	2.6030604475635593	2.6201171875	2.5927734375	2026-04-22 18:00:05.046794	6	0	0.03741770251043912	0.14220468203226724	0.2530670642852783
455	100	1.7433050847457627	37.63	0.92	\N	\N	\N	2.1226413532838984	2.16162109375	2.04345703125	2026-04-22 18:00:05.288027	5	0.002990535538772057	0.046663097348706474	0.07390047709147135	0.2918422698974609
30	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-03-31 17:05:13.591756	2	\N	\N	\N	\N
470	100	3.3685	9.705	2.31	\N	\N	\N	3.8110026041666667	3.85546875	3.7724609375	2026-04-23 09:15:23.161916	4	0.011484526316324871	0.25511546595891316	0.1739777406056722	2.9440996646881104
471	100	1.105508474576271	17.685	0.46	\N	\N	\N	2.94871391684322	3.0576171875	2.86572265625	2026-04-23 09:15:23.692741	7	0.009484389305114747	0.029924857139587403	0.07127170562744141	0.2757474104563395
472	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-23 09:15:25.033827	2	\N	\N	\N	\N
473	100	1.3139166666666666	1.825	1.205	\N	\N	\N	1.0056640625	1.03271484375	0.9794921875	2026-04-23 09:15:25.38592	3	0.006220517476399738	0.049895804087320965	0.12556896209716797	0.3077434539794922
474	100	2.1623706896551727	31.94	1.425	\N	\N	\N	2.9684733072916667	2.99755859375	2.88525390625	2026-04-23 09:15:25.786825	1	0.010062949498494464	0.16981123320261637	0.08852003415425619	0.3662484486897786
36	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-15 17:00:02.138299	2	\N	\N	\N	\N
475	100	0.9286666666666666	1.795	0.82	\N	\N	\N	2.6200427039194913	2.6494140625	2.6005859375	2026-04-23 09:15:26.090145	6	0	0.03838818582995184	0.18817350069681804	0.2606983661651611
476	100	2.4040833333333333	25.64	1.105	\N	\N	\N	2.1731201171875	2.21630859375	2.09033203125	2026-04-23 09:15:26.337666	5	0.004205790235285173	0.04919691095960901	0.11089859008789063	1.082341766357422
512	100	2.476833333333333	3.855	2.33	\N	\N	\N	3.8835774739583333	3.935546875	3.84765625	2026-04-24 09:09:48.178422	4	0.009530374685923259	0.24376425064216226	0.1047980785369873	0.46767497062683105
513	100	1.1579166666666665	25.895	0.48	\N	\N	\N	3.0371826171875	3.07373046875	2.95068359375	2026-04-24 09:09:48.638787	7	0.026716899871826176	0.05286701027552287	0.0734960397084554	0.235041348139445
514	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 09:09:49.104312	2	\N	\N	\N	\N
515	100	4.995083333333333	43.77	1.135	\N	\N	\N	0.691845703125	0.75927734375	0.634765625	2026-04-24 09:09:49.981378	3	0.03420592625935872	0.135127076625824	1.435896396636963	0.8184549649556477
516	100	2.3308474576271188	20.965	1.45	\N	\N	\N	2.95408501059322	3.0146484375	2.87353515625	2026-04-24 09:09:50.364594	1	0.22592595020929973	0.23707116619745888	0.42566685676574706	1.553232224782308
517	100	0.9646666666666667	1.55	0.81	\N	\N	\N	2.6007731119791666	2.62109375	2.56640625	2026-04-24 09:09:50.902224	6	9.046748533087262e-05	0.03531407469410007	0.14817163149515789	0.24487973848978678
518	100	1.62225	30.98	0.86	\N	\N	\N	2.2256754557291667	2.25244140625	2.041015625	2026-04-24 09:09:52.056296	5	0.00528143090716863	0.04641227657512083	0.07020708719889322	0.28391219774882
568	100	2.970593220338983	9.8	2.305	\N	\N	\N	3.7442647643008473	3.76953125	3.72802734375	2026-04-24 17:00:01.540991	4	0.009428673922005347	0.24554900735111562	0.1331643581390381	1.2296043713887532
47	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-15 19:00:02.791245	2	\N	\N	\N	\N
569	100	1.0961206896551725	31.29	0.465	\N	\N	\N	2.7876902613146552	2.8125	2.61279296875	2026-04-24 17:00:01.943066	7	6.620601072149762e-06	0.028448420055841996	0.07063366572062174	0.23640883763631185
570	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 17:00:02.493893	2	\N	\N	\N	\N
571	100	2.5666101694915255	18.205	1.185	\N	\N	\N	0.5437880693855932	0.56298828125	0.5263671875	2026-04-24 17:00:03.018413	3	0.0041221971026921675	0.11546977140135685	1.601301622390747	0.6444030284881592
572	100	2.3152586206896553	25.78	1.435	\N	\N	\N	2.7319998013771185	2.74755859375	2.65234375	2026-04-24 17:00:03.553847	1	0.027638533963995467	0.20745892298423638	0.3879286130269369	1.7363659699757894
573	100	0.9546610169491526	1.56	0.805	\N	\N	\N	2.5977886652542375	2.62109375	2.58447265625	2026-04-24 17:00:03.940185	6	0	0.03668204039858099	0.14821934700012207	0.3824617385864258
574	100	1.6216101694915255	36.955	0.86	\N	\N	\N	2.095504502118644	2.13720703125	1.93115234375	2026-04-24 17:00:04.368897	5	0.0047927705865157275	0.04482790846573679	0.07300496101379395	0.28642945289611815
605	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 22:00:02.685043	2	\N	\N	\N	\N
55	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 11:00:03.994516	2	\N	\N	\N	\N
606	100	1.2575423728813557	1.75	1.17	\N	\N	\N	0.5350734904661016	0.55810546875	0.51416015625	2026-04-24 22:00:03.077747	3	0.0020942101236117085	0.04850074347803149	0.0810081958770752	0.2707428773244222
607	100	2.18198275862069	29.11	1.46	\N	\N	\N	2.70262016684322	2.7177734375	2.54150390625	2026-04-24 22:00:03.570193	1	0.025389274338544425	0.18106313737772278	0.07934157053629558	0.32134246826171875
608	100	0.8810169491525424	1.91	0.81	\N	\N	\N	2.5851926641949152	2.60498046875	2.5732421875	2026-04-24 22:00:04.062396	6	0	0.03777053438383957	0.14745346705118814	0.2649735768636068
609	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 22:00:04.548203	5	\N	\N	\N	\N
659	100	2.4389830508474577	7.62	2.225	\N	\N	\N	3.8169690148305087	3.83837890625	3.7958984375	2026-04-25 15:00:01.922542	4	0.0006531406661211435	0.1924200992260949	0.10886181195576985	0.6547905762990316
660	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 15:00:02.750561	5	\N	\N	\N	\N
661	100	1.1324137931034484	26.765	0.5	\N	\N	\N	2.899683459051724	2.91748046875	2.80908203125	2026-04-25 15:00:03.627753	7	0	0.026659602149058197	0.0709368864695231	0.23621185620625815
662	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 15:00:03.997431	2	\N	\N	\N	\N
663	100	1.2183898305084746	1.62	1.135	\N	\N	\N	0.9162473516949152	0.9345703125	0.90185546875	2026-04-25 15:00:04.575479	3	0.0014122904761362882	0.04851589687800004	0.07789230346679688	0.2740520795186361
400	100	2.498559322033898	7.24	2.285	\N	\N	\N	3.8596894862288136	3.8857421875	3.8447265625	2026-04-22 11:00:00.967203	4	0.010029252585718186	0.2478468250016035	0.11341193517049154	0.6125852108001709
401	100	1.0901724137931035	22.04	0.46	\N	\N	\N	2.7484593884698274	2.77001953125	2.66650390625	2026-04-22 11:00:01.397094	7	3.31030053607488e-05	0.02865491107358771	0.07072114944458008	0.23360834121704102
402	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 11:00:03.42225	2	\N	\N	\N	\N
403	100	1.2509322033898307	1.715	1.13	\N	\N	\N	0.7997136520127118	0.82958984375	0.7763671875	2026-04-22 11:00:03.908167	3	0.0023960966983083954	0.05128699254181425	0.08530042966206869	0.1818553606669108
404	100	2.1288135593220336	28.515	1.4	\N	\N	\N	2.902683064088983	2.9169921875	2.80078125	2026-04-22 11:00:04.347136	1	0.009439384654416875	0.1702578298924333	0.07459325790405273	0.3172901471455892
405	100	0.8733898305084746	1.49	0.81	\N	\N	\N	2.6170881885593222	2.63525390625	2.6005859375	2026-04-22 11:00:04.88794	6	0	0.0362898954851874	0.14130528767903647	0.24131490389506022
62	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 12:00:03.763914	2	\N	\N	\N	\N
406	100	1.7365254237288135	42.41	0.935	\N	\N	\N	2.2318094544491527	2.2666015625	2.14990234375	2026-04-22 11:00:05.111983	5	0.002368592731023239	0.04313084694055411	0.07240460713704427	0.2794971466064453
456	100	2.980169491525424	13.975	2.305	\N	\N	\N	3.833785752118644	3.859375	3.794921875	2026-04-22 19:00:01.087917	4	0.010252338344767943	0.2534099753428314	0.16107892990112305	1.0228306293487548
457	100	1.0797413793103448	26.695	0.45	\N	\N	\N	2.699353448275862	2.7197265625	2.62646484375	2026-04-22 19:00:01.41175	7	2.31668504617982e-05	0.026831857875242074	0.070439084370931	0.23466938336690266
458	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 19:00:02.099073	2	\N	\N	\N	\N
459	100	1.2354237288135594	1.68	1.145	\N	\N	\N	0.8191042108050848	0.83544921875	0.80322265625	2026-04-22 19:00:02.513153	3	2.2065437446206303e-05	0.04930522255978342	0.08147870699564616	0.18285253842671711
68	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 13:00:02.634342	2	\N	\N	\N	\N
460	100	2.1757894736842105	30.76	1.415	\N	\N	\N	2.776325094288793	2.80078125	2.685546875	2026-04-22 19:00:02.960992	1	0.00865173760107008	0.17999262357162216	0.07908918062845866	0.32333989143371583
461	100	0.978050847457627	1.555	0.785	\N	\N	\N	2.6082329184322033	2.62451171875	2.595703125	2026-04-22 19:00:03.373208	6	0	0.03646345401632374	0.14527883529663085	0.27432001431783043
462	96.96969696969697	2.3171212121212124	37	0.94	\N	\N	\N	2.1088127367424243	2.1337890625	2.0244140625	2026-04-22 19:00:03.95141	5	0.005040414694583778	0.04681500203681714	0.07340477452133641	0.4061685330940015
477	100	3.432372881355932	11.87	2.27	\N	\N	\N	3.813857256355932	3.83984375	3.7861328125	2026-04-23 10:00:00.448821	4	0.009643742997767562	0.24757862171884312	0.16694347063700357	2.523240327835083
478	100	1.0869491525423731	18.26	0.47	\N	\N	\N	2.9207991260593222	2.93212890625	2.84423828125	2026-04-23 10:00:00.912965	7	0.00017103372994115796	0.026975125135001488	0.07069565455118815	0.23449360529581706
479	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-23 10:00:01.434077	2	\N	\N	\N	\N
75	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 14:00:03.038142	2	\N	\N	\N	\N
480	100	1.3436440677966102	1.75	1.205	\N	\N	\N	0.9975172139830508	1.01806640625	0.974609375	2026-04-23 10:00:01.829762	3	0.0007204972283314851	0.05010758044356007	0.15962994893391927	0.33500625292460123
481	100	2.1766964285714283	31.155	1.415	\N	\N	\N	2.938274515086207	2.96826171875	2.80859375	2026-04-23 10:00:02.251218	1	0.014842353432865465	0.18393950462341307	0.08060369491577149	0.3964027245839437
482	100	0.8837288135593221	1.715	0.815	\N	\N	\N	2.6081749867584745	2.6376953125	2.5986328125	2026-04-23 10:00:03.002621	6	0	0.03580611730876722	0.140700626373291	0.23820281028747559
483	100	1.992542372881356	25.64	1.055	\N	\N	\N	2.1559851694915255	2.20166015625	2.09033203125	2026-04-23 10:00:03.887296	5	0.0019584319421223234	0.04600198918200554	0.08764591217041015	0.5231227874755859
519	100	2.706186440677966	8.445	2.325	\N	\N	\N	3.8488645391949152	3.86767578125	3.82421875	2026-04-24 10:00:00.864058	4	0.009573907528893422	0.2488001930302587	0.1306406021118164	0.9440303961435954
520	100	1.1039655172413794	26.505	0.48	\N	\N	\N	3.0220484240301726	3.041015625	2.92724609375	2026-04-24 10:00:01.274303	7	0.00020302045143256753	0.027893326807830295	0.0704106330871582	0.23514426549275716
82	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 17:00:02.278876	2	\N	\N	\N	\N
521	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 10:00:01.829544	2	\N	\N	\N	\N
522	100	8.883474576271187	47.395	1.17	\N	\N	\N	0.5991045418432204	0.6796875	0.51611328125	2026-04-24 10:00:02.324903	3	0.04805238335819568	0.32223461506730416	5.527395645777385	1.657957092920939
523	100	2.752938596491228	21.88	1.46	\N	\N	\N	2.826966366525424	2.9072265625	2.72216796875	2026-04-24 10:00:02.840958	1	0.2835679641012418	0.3103882122039795	1.4322255293528239	5.329534085591634
524	100	0.9241525423728814	1.55	0.815	\N	\N	\N	2.5829250529661016	2.611328125	2.56640625	2026-04-24 10:00:03.357036	6	9.202726956071524e-05	0.03680203370880662	0.14706865946451822	0.3699186325073242
525	100	1.632542372881356	30.98	0.865	\N	\N	\N	2.2165817002118646	2.25244140625	2.041015625	2026-04-24 10:00:03.832808	5	0.0052649307250976565	0.047119861635668524	0.07306044896443685	0.3189532279968262
575	100	2.4712711864406782	4.29	2.305	\N	\N	\N	3.756438691737288	3.78662109375	3.73193359375	2026-04-24 18:00:01.497558	4	0.009668836270348499	0.24416569822925632	0.10869765281677246	0.6444798787434896
89	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 18:19:32.334264	2	\N	\N	\N	\N
576	100	1.1026724137931034	31.78	0.48	\N	\N	\N	2.7815278151939653	2.79833984375	2.6328125	2026-04-24 18:00:02.117452	7	0	0.03545164609359483	0.07032961845397949	0.2351330598195394
577	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 18:00:02.656085	2	\N	\N	\N	\N
578	100	3.932627118644068	32.44	1.18	\N	\N	\N	0.5376307600635594	0.56298828125	0.51318359375	2026-04-24 18:00:03.209233	3	0.004476364911612818	0.15625893188735185	4.437204074859619	0.9914083480834961
579	100	2.563830409356725	26.835	1.405	\N	\N	\N	2.719668630826271	2.74169921875	2.63720703125	2026-04-24 18:00:03.890494	1	0.027869575953079477	0.20847659466630322	0.813582197825114	4.412191486358642
580	100	0.952542372881356	1.565	0.83	\N	\N	\N	2.5893637447033897	2.60595703125	2.578125	2026-04-24 18:00:04.324433	6	0	0.03641085792006108	0.14460994402567545	0.2494946002960205
581	100	1.6189830508474576	37.8	0.845	\N	\N	\N	2.107562566207627	2.14013671875	1.94677734375	2026-04-24 18:00:04.752962	5	0.004867842824835527	0.045837467762461885	0.07274055480957031	0.2861967404683431
96	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 19:00:01.972999	2	\N	\N	\N	\N
610	100	2.4015254237288137	3.78	2.255	\N	\N	\N	3.984921212923729	4.00048828125	3.96728515625	2026-04-24 23:01:02.051094	4	0.009683960575168417	0.24585029860674326	0.09820389747619629	0.46277955373128254
611	100	1.1043103448275862	34.05	0.475	\N	\N	\N	2.8504680765086206	2.873046875	2.720703125	2026-04-24 23:01:02.38417	7	0	0.028112698894436076	0.07060472170511882	0.23534933725992838
612	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 23:01:03.031202	2	\N	\N	\N	\N
613	100	1.275508474576271	1.765	1.185	\N	\N	\N	0.532466565148305	0.5556640625	0.51025390625	2026-04-24 23:01:04.886196	3	0.004103551799968138	0.047779072260452526	0.08224143981933593	0.27137630780537925
614	100	2.1750862068965517	29.485	1.465	\N	\N	\N	2.699417372881356	2.71142578125	2.53466796875	2026-04-24 23:01:05.318879	1	0.025493504637378758	0.17267306230835996	0.08135143915812175	0.3225170930226644
615	100	0.873135593220339	1.48	0.805	\N	\N	\N	2.5849857653601696	2.60791015625	2.5751953125	2026-04-24 23:01:05.729945	6	0.00015667769868495102	0.03691761148386988	0.14303921063741049	0.2426986535390218
103	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 20:00:02.70679	2	\N	\N	\N	\N
104	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-16 20:00:02.864265	5	\N	\N	\N	\N
616	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 23:01:06.110739	5	\N	\N	\N	\N
617	100	2.5714166666666665	10.68	2.3	\N	\N	\N	3.8614501953125	3.9072265625	3.802734375	2026-04-25 09:29:34.420525	4	0.009364963690439859	0.24775462881724042	0.11516052881876628	0.7142415841420492
618	100	1.0941525423728815	29.55	0.46	\N	\N	\N	3.017578125	3.04345703125	2.875	2026-04-25 09:29:36.581427	7	0.0002701780001322428	0.02905310249328613	0.07122894922892252	0.23621880213419597
619	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 09:29:37.723614	2	\N	\N	\N	\N
620	100	1.2658333333333334	1.71	1.145	\N	\N	\N	0.9197184244791666	0.9345703125	0.9033203125	2026-04-25 09:29:38.520896	3	0.0006563477516174316	0.04839222796758016	0.1458201249440511	0.27601416905721027
110	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-17 10:00:02.714531	2	\N	\N	\N	\N
621	100	2.2171929824561403	33.525	1.425	\N	\N	\N	2.9660437632415255	3.0126953125	2.83251953125	2026-04-25 09:29:41.076767	1	0.09711813592910766	0.21313154776891075	0.08337531089782715	0.38784796396891275
622	100	0.96775	1.645	0.87	\N	\N	\N	2.596329752604167	2.61669921875	2.580078125	2026-04-25 09:29:42.764192	6	0	0.03818844779063079	0.1427991231282552	0.24042056401570638
623	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 09:29:44.078504	5	\N	\N	\N	\N
664	100	2.1688218390804597	36.82	1.455	\N	\N	\N	2.906787936970339	2.921875	2.74072265625	2026-04-25 15:00:04.975702	1	0.00874513415967004	0.1789322963003385	0.08321989377339681	0.3235264778137207
665	100	0.9827966101694915	1.415	0.89	\N	\N	\N	2.5896285752118646	2.6044921875	2.578125	2026-04-25 15:00:05.386025	6	5.611222365806842e-06	0.037241348726996054	0.149289067586263	0.2698461691538493
729	100	2.346101694915254	3.55	2.225	\N	\N	\N	4.256538003177966	4.2763671875	4.23876953125	2026-04-26 14:00:02.34249	4	0.00025817062895176773	0.18436216419026002	0.09871613184611003	0.32485326131184894
730	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 14:00:03.483497	5	\N	\N	\N	\N
731	100	1.141896551724138	23.15	0.52	\N	\N	\N	2.9975249191810347	3.01220703125	2.90380859375	2026-04-26 14:00:07.627309	7	0.00023279303211276814	0.026413529606188757	0.07084601720174154	0.23431429862976075
732	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 14:00:08.401231	2	\N	\N	\N	\N
733	100	1.3596610169491525	1.8	1.2	\N	\N	\N	0.9737652277542372	0.9931640625	0.95361328125	2026-04-26 14:00:09.07831	3	3.309896436788268e-06	0.04800893912881107	0.07889459927876791	0.27553044954935707
734	100	2.1604310344827584	30.22	1.47	\N	\N	\N	2.9293564618644066	2.9462890625	2.70703125	2026-04-26 14:00:10.750562	1	0.0087056429911468	0.17403166415327687	0.08095831871032715	0.3221269130706787
407	100	2.4305084745762713	4.03	2.3	\N	\N	\N	3.8593667240466103	3.88134765625	3.83837890625	2026-04-22 12:00:03.290419	4	0.010156845803988184	0.24916653794757393	0.11013476053873698	0.46261884371439616
117	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-17 11:00:03.852561	2	\N	\N	\N	\N
408	100	1.076551724137931	22.585	0.455	\N	\N	\N	2.749646417025862	2.76611328125	2.66455078125	2026-04-22 12:00:03.793636	7	7.72298392602953e-06	0.0301197436704474	0.07125218709309895	0.6864649136861165
409	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 12:00:04.501234	2	\N	\N	\N	\N
410	100	1.2466949152542375	1.745	1.145	\N	\N	\N	0.7838817531779662	0.80517578125	0.765625	2026-04-22 12:00:05.130839	3	0.006302854247012381	0.048189891879841434	0.07982643445332845	0.18123407363891603
411	100	2.153559322033898	34.84	1.44	\N	\N	\N	2.881885593220339	2.90283203125	2.7353515625	2026-04-22 12:00:05.935886	1	0.011064127905894134	0.1827403879973848	0.07770536740620931	0.3202797889709473
412	100	0.9158474576271186	3.67	0.8	\N	\N	\N	2.606875662076271	2.62548828125	2.59033203125	2026-04-22 12:00:06.52462	6	0	0.037332398809235674	0.6107906500498453	0.24963475863138834
413	100	1.7530508474576272	41.88	0.93	\N	\N	\N	2.2193210407838984	2.2587890625	2.1337890625	2026-04-22 12:00:07.023962	5	0.002602432514059133	0.04585556417703629	0.07300626436869304	0.2824812412261963
124	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-17 12:00:07.579404	2	\N	\N	\N	\N
463	100	2.4365254237288134	3.845	2.32	\N	\N	\N	3.8392230534957625	3.85107421875	3.81689453125	2026-04-22 20:01:02.955426	4	0.009581258256556624	0.2441337512711347	0.10818134943644206	0.4611431916554769
464	100	1.0886206896551724	27.15	0.45	\N	\N	\N	2.7023841594827585	2.72607421875	2.53955078125	2026-04-22 20:01:03.324816	7	0	0.026596818051095737	0.0699034849802653	0.23350704511006673
465	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 20:01:03.556621	2	\N	\N	\N	\N
466	100	1.3194915254237287	1.835	1.195	\N	\N	\N	0.821388373940678	0.8427734375	0.806640625	2026-04-22 20:01:03.93016	3	2.8686685077214646e-05	0.048849224316871775	0.08517656326293946	0.18270756403605143
129	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-17 15:00:03.059488	2	\N	\N	\N	\N
467	100	2.188421052631579	30.35	1.455	\N	\N	\N	2.7555283368644066	2.77587890625	2.67724609375	2026-04-22 20:01:04.245282	1	0.008608289169052898	0.17251475528135138	0.0783216635386149	0.3269574324289958
468	100	0.9594915254237288	1.475	0.81	\N	\N	\N	2.6020425052966103	2.61962890625	2.59033203125	2026-04-22 20:01:04.528792	6	0	0.03760696460460794	0.14217815399169922	0.24147756894429526
469	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 20:01:04.763349	5	\N	\N	\N	\N
484	100	3.016271186440678	11.175	2.31	\N	\N	\N	3.8172255693855934	3.85302734375	3.794921875	2026-04-23 11:00:00.886715	4	0.05194233554904744	0.3403333277621512	0.29985334078470866	1.6252854824066163
485	100	1.0968103448275863	18.895	0.475	\N	\N	\N	2.909154431573276	2.92578125	2.81884765625	2026-04-23 11:00:01.622442	7	3.08940370204085e-05	0.02635960093999313	0.07020436922709147	0.23431409200032552
486	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-23 11:00:02.083173	2	\N	\N	\N	\N
136	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-17 17:01:02.724553	2	\N	\N	\N	\N
487	100	1.3776271186440678	1.885	1.24	\N	\N	\N	0.9933047537076272	1.013671875	0.97314453125	2026-04-23 11:00:02.476844	3	8.38520567295915e-05	0.049201166831840906	0.08872618675231933	0.2663335641225179
488	100	2.1567857142857143	30.64	1.42	\N	\N	\N	2.914306640625	2.9306640625	2.81640625	2026-04-23 11:00:02.644156	1	0.00866561356237379	0.17028635477615617	0.07788313229878743	0.33020706176757814
489	100	0.8591525423728813	1.605	0.8	\N	\N	\N	2.605328058792373	2.62451171875	2.58740234375	2026-04-23 11:00:03.208769	6	0	0.03666590065791689	0.1447735627492269	0.25611310005187987
490	100	1.9441525423728814	26.255	1.05	\N	\N	\N	2.1472292108050848	2.1962890625	2.07958984375	2026-04-23 11:00:03.610017	5	0.0034690458686263475	0.044869072437286384	\N	0.3110036055246989
526	100	9.234661016949152	26.22	2.36	\N	\N	\N	3.79246391684322	3.9169921875	3.75048828125	2026-04-24 11:01:02.061213	4	0.014264412734468103	0.29904060056654075	0.8994645277659098	14.25675630569458
527	100	1.0961206896551725	27.1	0.46	\N	\N	\N	2.8972504714439653	3.0087890625	2.8193359375	2026-04-24 11:01:02.374473	7	0.008074001376911746	0.03467377436363091	0.07421994209289551	1.7856265385945638
143	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 14:00:03.182253	2	\N	\N	\N	\N
144	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 14:00:04.161511	5	\N	\N	\N	\N
528	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 11:01:02.701661	2	\N	\N	\N	\N
529	100	4.13635593220339	35.615	1.23	\N	\N	\N	0.537109375	0.576171875	0.51611328125	2026-04-24 11:01:03.082969	3	0.022737889047396383	0.19065948389344298	2.915997314453125	0.869757350285848
530	100	2.8614473684210524	22.95	1.42	\N	\N	\N	2.78123344809322	2.81201171875	2.69873046875	2026-04-24 11:01:03.581377	1	0.04191073854090804	0.34389848563630704	0.5511113166809082	2.9587986628214518
531	100	1.0928813559322035	6.925	0.805	\N	\N	\N	2.5939403469279663	2.60888671875	2.505859375	2026-04-24 11:01:04.022603	6	0	0.03661938583641721	1.7612897237141927	0.6305654525756836
532	100	1.6614655172413793	31.79	0.87	\N	\N	\N	2.195232522898707	2.24072265625	2.00927734375	2026-04-24 11:01:04.423516	5	0.004718080319856342	0.04918048289784214	0.07299702962239583	0.2877193291982015
150	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 15:01:04.310347	2	\N	\N	\N	\N
151	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 15:01:04.566045	5	\N	\N	\N	\N
582	100	2.4400847457627117	3.895	2.29	\N	\N	\N	3.787548000529661	3.83056640625	3.7587890625	2026-04-24 19:01:02.500152	4	0.009307804915864588	0.24584106994887528	0.11705304781595866	0.4661725044250488
583	100	1.1071551724137931	32.57	0.48	\N	\N	\N	2.7930024245689653	2.8232421875	2.59716796875	2026-04-24 19:01:02.952305	7	0.0010306023743193028	0.02842661809113066	0.0714712142944336	0.6361504077911377
584	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 19:01:03.397916	2	\N	\N	\N	\N
624	100	3.368728813559322	12.06	2.325	\N	\N	\N	3.8057964777542375	3.90673828125	3.716796875	2026-04-25 10:00:01.885077	4	0.009498334335068526	0.24657371537160064	0.24820014635721843	3.224915790557861
625	100	1.1168103448275863	30.12	0.46	\N	\N	\N	3.001574286099138	3.01806640625	2.7958984375	2026-04-25 10:00:02.605909	7	0.00026593014345330706	0.026205405704045698	0.07124611536661783	0.2361131191253662
157	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 16:00:02.437341	2	\N	\N	\N	\N
158	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 16:00:02.865013	5	\N	\N	\N	\N
626	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 10:00:02.948308	2	\N	\N	\N	\N
627	100	1.2552542372881357	1.585	1.135	\N	\N	\N	0.9194998013771186	0.93994140625	0.900390625	2026-04-25 10:00:03.578952	3	0.00019528696092508608	0.04817482463384079	0.07871224085489908	0.27385568618774414
628	100	2.2149122807017543	34.085	1.425	\N	\N	\N	2.952777409957627	2.97265625	2.74169921875	2026-04-25 10:00:04.079826	1	0.09326386128441763	0.21037886215468585	0.0812374750773112	0.32185770670572916
629	100	0.9660169491525423	1.645	0.87	\N	\N	\N	2.60107421875	2.6171875	2.5849609375	2026-04-25 10:00:04.465219	6	0	0.03817820516125909	0.14244378407796224	0.24154404004414876
630	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 10:00:05.058376	5	\N	\N	\N	\N
164	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 17:01:19.963521	2	\N	\N	\N	\N
165	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 17:01:20.482394	5	\N	\N	\N	\N
666	100	2.307033898305085	3.405	2.195	\N	\N	\N	3.815288996292373	3.83203125	3.798828125	2026-04-25 16:00:02.292215	4	0.0006476452391026384	0.19018943043078407	0.07894783020019532	0.3206065972646078
667	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 16:00:03.213016	5	\N	\N	\N	\N
668	100	1.1359482758620691	26.335	0.52	\N	\N	\N	2.8959455818965516	2.919921875	2.763671875	2026-04-25 16:00:03.727373	7	3.199932938915188e-05	0.026356703548108117	0.07099836667378744	0.23622260093688965
669	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 16:00:04.148779	2	\N	\N	\N	\N
670	100	1.2377966101694915	2.52	1.12	\N	\N	\N	0.9153866525423728	0.9365234375	0.875	2026-04-25 16:00:04.581802	3	0.013831382525169243	0.06319689831491243	0.0733859380086263	0.27335025469462076
171	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 20:38:48.94703	2	\N	\N	\N	\N
172	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-18 20:38:49.147572	5	\N	\N	\N	\N
671	100	2.1695175438596492	36.95	1.44	\N	\N	\N	2.8897146451271185	2.912109375	2.7177734375	2026-04-25 16:00:05.127066	1	0.008742258265867072	0.17582254878545212	0.07360429763793945	0.32022231419881186
672	100	0.978728813559322	1.595	0.895	\N	\N	\N	2.592955508474576	2.61328125	2.5810546875	2026-04-25 16:00:05.695767	6	0	0.03636748116591881	0.1429623285929362	0.24123311042785645
701	100	2.342033898305085	3.555	2.23	\N	\N	\N	4.235632944915254	4.25439453125	4.21533203125	2026-04-26 10:00:01.365712	4	0.00040160373105841167	0.18686644360170526	0.09063781102498372	0.3215215047200521
702	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 10:00:01.980464	5	\N	\N	\N	\N
703	100	1.1368965517241378	20.87	0.515	\N	\N	\N	3.0351057381465516	3.0556640625	2.9384765625	2026-04-26 10:00:02.90126	7	0.002987465131080757	0.02685376878512108	0.07081324259440104	0.23444266319274903
178	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 09:00:04.024857	2	\N	\N	\N	\N
704	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 10:00:03.430434	2	\N	\N	\N	\N
705	100	1.3564406779661018	1.835	1.1	\N	\N	\N	0.9773569915254238	1.00244140625	0.95703125	2026-04-26 10:00:03.851617	3	0.0003541524531477589	0.051701730307886155	0.08266746203104655	0.29424729347229006
706	100	2.205740740740741	28.165	1.43	\N	\N	\N	2.9778369968220337	2.9990234375	2.89013671875	2026-04-26 10:00:04.153219	1	0.00896689091698598	0.16822763911748337	0.0818754514058431	0.32234694163004557
707	100	0.9699152542372882	1.615	0.88	\N	\N	\N	2.5834298861228815	2.6064453125	2.5654296875	2026-04-26 10:00:04.608355	6	0	0.037477750778198246	0.16754077275594076	0.23661662737528483
735	100	0.9734745762711865	1.575	0.9	\N	\N	\N	2.57521186440678	2.60009765625	2.5625	2026-04-26 14:00:11.749384	6	1.7955056552229256e-05	0.03718359395077354	0.1699860413869222	0.2482026735941569
747	100	1.383135593220339	2.28	1.225	\N	\N	\N	0.977928032309322	0.99609375	0.94482421875	2026-04-26 16:01:05.633936	3	0.00021405898918539792	0.06393907401521327	0.0738147258758545	0.2751858075459798
414	100	2.72364406779661	10.885	2.315	\N	\N	\N	3.8513887049788136	3.884765625	3.81005859375	2026-04-22 13:00:01.845875	4	0.009489671416201833	0.250558190426584	0.13240666389465333	1.0767218112945556
415	100	1.0801724137931035	23.095	0.46	\N	\N	\N	2.7132357893318964	2.74365234375	2.63134765625	2026-04-22 13:00:02.311397	7	5.185741489216433e-05	0.03433486211097847	0.07147693634033203	0.7213131268819173
181	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 09:00:05.403336	5	\N	\N	\N	\N
416	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 13:00:02.802962	2	\N	\N	\N	\N
417	100	1.353050847457627	2.775	1.13	\N	\N	\N	0.777393405720339	0.7978515625	0.748046875	2026-04-22 13:00:03.460328	3	0.00460639630333852	0.059113385636927716	0.6556612968444824	0.24619288444519044
418	100	2.22219298245614	34.41	1.435	\N	\N	\N	2.8544673596398304	2.88330078125	2.75439453125	2026-04-22 13:00:03.855856	1	0.008640797825182898	0.17130298388206353	0.1369202454884847	0.8634272257486979
185	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 10:00:02.092599	2	\N	\N	\N	\N
419	100	1.0085593220338984	2.485	0.835	\N	\N	\N	2.610790188029661	2.6376953125	2.5390625	2026-04-22 13:00:04.713046	6	0	0.03732124525925209	0.6479605674743653	0.2508959134419759
420	100	1.7337288135593218	41.03	0.895	\N	\N	\N	2.199649099576271	2.236328125	2.1279296875	2026-04-22 13:00:05.200202	5	0.005927371649906553	0.04388632526397705	0.07035358746846516	0.28053642908732096
188	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 10:00:02.94823	5	\N	\N	\N	\N
491	100	3.167372881355932	11.1	2.315	\N	\N	\N	3.806011652542373	3.828125	3.791015625	2026-04-23 12:00:01.53107	4	0.010209327471458305	0.24887773352154233	0.23210477828979492	2.567821915944417
492	100	1.0963793103448276	19.395	0.475	\N	\N	\N	2.9032866379310347	2.9248046875	2.8232421875	2026-04-23 12:00:02.030558	7	0	0.026943408513473252	0.07046238581339519	0.23546593983968098
493	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-23 12:00:02.40688	2	\N	\N	\N	\N
192	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 11:00:02.61632	2	\N	\N	\N	\N
494	100	1.894406779661017	22.245	1.21	\N	\N	\N	0.9847556938559322	1.0078125	0.95556640625	2026-04-23 12:00:03.13181	3	0.005187154220322431	0.055279735306562	0.4401812712351481	0.36082932154337566
495	100	2.1695175438596492	30.015	1.435	\N	\N	\N	2.8988264698093222	2.9189453125	2.8193359375	2026-04-23 12:00:03.533364	1	0.013817384687520692	0.1811506880744029	0.11217295328776042	0.653443177541097
195	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 11:00:03.654181	5	\N	\N	\N	\N
496	100	0.8393220338983052	1.595	0.785	\N	\N	\N	2.608001191737288	2.65087890625	2.5869140625	2026-04-23 12:00:03.759109	6	0	0.037020601239697686	0.14509145418802896	0.2583457946777344
497	100	2.1441525423728813	27.17	1.04	\N	\N	\N	2.1345587261652543	2.171875	2.05517578125	2026-04-23 12:00:04.106972	5	0.003273035146422305	0.1592877413364167	0.22119582494099935	0.2867136478424072
533	100	6.9680508474576275	26.61	2.365	\N	\N	\N	3.811672404661017	3.97265625	3.7568359375	2026-04-24 12:00:01.152283	4	0.01050922765570172	0.25487442921783965	0.5240075429280598	10.534739049275716
199	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 12:00:03.328522	2	\N	\N	\N	\N
534	100	1.0886440677966103	27.8	0.46	\N	\N	\N	2.8280422404661016	2.84716796875	2.64013671875	2026-04-24 12:00:01.669415	7	1.4343746637893935e-05	0.02794811248779297	0.06999516487121582	0.2351422627766927
535	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 12:00:02.14582	2	\N	\N	\N	\N
202	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 12:00:04.565426	5	\N	\N	\N	\N
536	100	13.353983050847457	72.29	1.24	\N	\N	\N	0.5289410090042372	0.57177734375	0.498046875	2026-04-24 12:00:02.836339	3	0.010730556552692996	0.5299920625201726	11.921990489959716	2.4379103660583494
537	100	3.520267857142857	24.265	1.48	\N	\N	\N	2.762476427801724	2.78857421875	2.673828125	2026-04-24 12:00:03.784775	1	0.09360147072097003	0.40310121326123255	2.389171075820923	11.414442332585653
538	100	0.8974576271186441	1.395	0.8	\N	\N	\N	2.6014466366525424	2.6181640625	2.5888671875	2026-04-24 12:00:04.179568	6	0	0.03653721940928492	0.14164802233378093	0.23851892153422039
206	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 14:04:50.970895	2	\N	\N	\N	\N
539	100	1.6338135593220338	32.705	0.85	\N	\N	\N	2.1776102356991527	2.20947265625	2.0048828125	2026-04-24 12:00:04.676657	5	0.004319314956665039	0.044500197360390105	0.07092343966166179	0.2856022834777832
585	100	6.347542372881356	33.655	1.18	\N	\N	\N	0.5509964247881356	0.58154296875	0.51123046875	2026-04-24 19:01:03.815018	3	0.016246506480847373	0.15444290597560043	7.2339272181193035	1.3513794104258219
209	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 14:04:51.769395	5	\N	\N	\N	\N
586	100	2.8010526315789472	27.31	1.415	\N	\N	\N	2.715572033898305	2.7333984375	2.6396484375	2026-04-24 19:01:04.405256	1	0.0296011391332594	0.22982752622184108	1.3007438023885092	7.0945212841033936
587	100	0.9733898305084746	1.7	0.785	\N	\N	\N	2.590224443855932	2.60986328125	2.5654296875	2026-04-24 19:01:04.794142	6	1.6548673985368114e-05	0.035924638715283626	0.5615423997243245	0.6675099690755208
588	96.875	2.20921875	38.75	0.85	\N	\N	\N	2.091827392578125	2.13134765625	1.93603515625	2026-04-24 19:01:05.172354	5	0.015284804067304057	0.0500259094853555	0.07335776090621948	0.42249417304992676
213	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 15:00:02.158196	2	\N	\N	\N	\N
631	100	9.706525423728813	66.285	2.33	\N	\N	\N	3.7402012711864407	3.7646484375	3.70703125	2026-04-25 11:01:03.389049	4	0.009981714668920484	0.2528476621336856	0.5303898652394613	10.69926643371582
632	100	1.1236206896551724	28.87	0.49	\N	\N	\N	2.9856041217672415	3.0048828125	2.8623046875	2026-04-25 11:01:05.121305	7	0.0011385954840708588	0.026884916111574335	0.07148385047912598	0.43652888933817546
216	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 15:00:03.48186	5	\N	\N	\N	\N
633	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 11:01:06.690979	2	\N	\N	\N	\N
634	100	1.2497457627118644	1.625	1.11	\N	\N	\N	0.9213784427966102	0.9384765625	0.90673828125	2026-04-25 11:01:07.272442	3	0.00014895616951635327	0.049192911891613976	0.0782200813293457	0.27406922976175946
635	100	2.1748214285714282	34.54	1.43	\N	\N	\N	2.9415221133474576	2.9580078125	2.765625	2026-04-25 11:01:08.210148	1	0.008691996719877599	0.1836329692905232	0.07809074719746907	0.3213844299316406
220	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 16:00:03.47529	2	\N	\N	\N	\N
636	100	0.9827966101694915	1.735	0.865	\N	\N	\N	2.6023156117584745	2.623046875	2.587890625	2026-04-25 11:01:08.786703	6	0	0.03880288683134934	0.3553498109181722	0.489234717686971
637	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 11:01:09.034349	5	\N	\N	\N	\N
223	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 16:00:04.581131	5	\N	\N	\N	\N
673	100	2.314491525423729	3.39	2.185	\N	\N	\N	3.860045352224576	3.88427734375	3.82470703125	2026-04-25 17:00:02.080407	4	0.0006818464246846861	0.1908756526041839	0.07982920010884603	0.32302101453145343
674	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 17:00:02.386675	5	\N	\N	\N	\N
675	100	1.1372413793103449	25.9	0.52	\N	\N	\N	2.8917951912715516	2.90380859375	2.7822265625	2026-04-25 17:00:02.717443	7	0.0007308280879053576	0.02790006736229206	0.07128936449686686	0.2373903751373291
227	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 17:01:12.642175	2	\N	\N	\N	\N
676	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 17:00:03.08985	2	\N	\N	\N	\N
677	100	1.215593220338983	1.68	1.13	\N	\N	\N	0.9034113479872882	0.92724609375	0.8896484375	2026-04-25 17:00:03.573646	3	0.005377938706996078	0.04971902265387066	0.0755897839864095	0.277990468343099
230	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 17:01:29.662495	5	\N	\N	\N	\N
678	100	1.9394827586206898	25.180000000000003	1.45	\N	\N	\N	2.8795683262711864	2.89697265625	2.69140625	2026-04-25 17:00:04.04269	1	0.00886883234573623	0.17546845242128534	0.07382164001464844	0.3201537768046061
679	100	0.9792372881355932	1.55	0.875	\N	\N	\N	2.596439684851695	2.61376953125	2.578125	2026-04-25 17:00:04.299169	6	0	0.03629560996746194	0.15213621457417806	0.3743520895640055
708	100	2.3347457627118646	3.515	2.23	\N	\N	\N	4.240929555084746	4.26513671875	4.2236328125	2026-04-26 11:00:01.317323	4	0.00038615323729434257	0.18724861435971016	0.0857943852742513	0.3193991661071777
234	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 18:00:01.868543	2	\N	\N	\N	\N
709	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 11:00:01.740862	5	\N	\N	\N	\N
710	100	1.1307758620689654	21.435	0.515	\N	\N	\N	3.0102202316810347	3.0205078125	2.93603515625	2026-04-26 11:00:02.31282	7	5.406767635022179e-05	0.02664971901198565	0.07099386850992838	0.23446939786275228
237	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-19 18:00:02.923603	5	\N	\N	\N	\N
711	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 11:00:02.642249	2	\N	\N	\N	\N
712	100	1.3299152542372883	1.79	1.22	\N	\N	\N	0.967036877648305	0.98828125	0.94873046875	2026-04-26 11:00:03.129681	3	0.0037885269876253807	0.05013760970810713	0.07621180216471354	0.2751028537750244
713	100	2.1584649122807016	28.63	1.43	\N	\N	\N	2.9561291710805087	2.96826171875	2.78662109375	2026-04-26 11:00:03.844074	1	0.008564644344782426	0.17809909173997782	0.07667581240336101	0.32096718152364095
241	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-20 10:00:03.967258	2	\N	\N	\N	\N
714	100	0.963135593220339	1.58	0.845	\N	\N	\N	2.582759533898305	2.595703125	2.57568359375	2026-04-26 11:00:04.339774	6	0	0.03774488761507232	0.16779505411783854	0.2356560230255127
736	100	2.339745762711864	3.645	2.225	\N	\N	\N	4.264482918432203	4.27978515625	4.24462890625	2026-04-26 15:01:02.446585	4	0.00032106480355990137	0.186122914330434	0.08009858131408691	0.3184695243835449
737	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 15:01:02.850854	5	\N	\N	\N	\N
738	100	1.131896551724138	23.745	0.505	\N	\N	\N	2.994586813038793	3.00439453125	2.904296875	2026-04-26 15:01:03.264433	7	0	0.02660062951556707	0.07047923405965169	0.23435192108154296
739	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 15:01:03.79446	2	\N	\N	\N	\N
740	100	1.3527118644067797	1.755	1.23	\N	\N	\N	0.9767362950211864	1.00341796875	0.96142578125	2026-04-26 15:01:04.208065	3	1.5446614410917638e-05	0.04798843125165519	0.07434887886047363	0.2741391181945801
741	100	2.1904017857142857	30.775	1.435	\N	\N	\N	2.9132711476293105	2.9287109375	2.7578125	2026-04-26 15:01:04.511578	1	0.011697184675830904	0.17140024362984352	0.0737102190653483	0.32020281155904134
421	100	3.8675	12.455	2.275	\N	\N	\N	3.855452473958333	3.8779296875	3.83544921875	2026-04-22 14:01:14.563425	4	0.009564006964365641	0.25531340503692623	0.3475244839986165	6.984073003133138
422	100	1.2482203389830508	23.9	0.465	\N	\N	\N	2.701213254766949	2.74267578125	2.6162109375	2026-04-22 14:01:15.051348	7	0.014583974679311116	0.14913376426696778	1.0309773127237956	1.400983730951945
423	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 14:01:15.52273	2	\N	\N	\N	\N
424	100	1.2164406779661017	1.645	1.12	\N	\N	\N	0.7822513903601694	0.80615234375	0.7685546875	2026-04-22 14:01:15.765592	3	0.0003618621826171875	0.04728845434673762	0.07784077326456705	0.18085336685180664
425	100	2.0949152542372884	33.795	1.365	\N	\N	\N	2.8419623940677967	2.857421875	2.7216796875	2026-04-22 14:01:15.990054	1	0.008831863726599741	0.18205322799036058	0.07892120679219564	0.3213726202646891
248	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-20 11:00:02.247985	2	\N	\N	\N	\N
426	100	1.0722033898305083	4.585	0.83	\N	\N	\N	2.631389036016949	2.65869140625	2.6005859375	2026-04-22 14:01:16.365672	6	0.0003662820589744439	0.03706322977098368	1.3716923077901204	0.8301877021789551
427	100	1.7558474576271186	40.38	0.93	\N	\N	\N	2.180225436970339	2.2119140625	2.10888671875	2026-04-22 14:01:16.807135	5	0.002525038061470821	0.044677986934267236	0.06932711601257324	0.27772936820983884
498	100	3.1704237288135593	16.395	2.285	\N	\N	\N	3.8030074814618646	3.82080078125	3.771484375	2026-04-23 13:00:00.686236	4	0.010015419297299141	0.25111006785247286	0.20424168904622395	3.3743718306223554
499	100	1.093793103448276	19.905	0.465	\N	\N	\N	2.900811557112069	2.9140625	2.8134765625	2026-04-23 13:00:01.035069	7	2.2066730563923466e-05	0.028656261411763854	0.07038995424906412	0.23648056983947754
500	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-23 13:00:01.42688	2	\N	\N	\N	\N
501	100	5.100338983050848	45.18	1.245	\N	\N	\N	0.9382034560381356	0.98193359375	0.8984375	2026-04-23 13:00:01.821007	3	0.016673113612805383	0.10221076852184231	0.580141830444336	0.48713857332865396
255	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-20 12:07:20.940655	2	\N	\N	\N	\N
502	100	2.2427586206896555	29.71	1.41	\N	\N	\N	2.866897841631356	2.8916015625	2.74853515625	2026-04-23 13:00:02.32517	1	0.011372741763874636	0.21374334302999207	0.2543437639872233	0.7633180618286133
503	100	0.8984745762711864	1.7	0.785	\N	\N	\N	2.6160040386652543	2.6455078125	2.5927734375	2026-04-23 13:00:02.836759	6	0	0.03674223587430756	0.1576674461364746	0.4502105236053467
504	100	1.9644915254237287	27.695	1.07	\N	\N	\N	2.1226910090042375	2.15869140625	2.05517578125	2026-04-23 13:00:04.971917	5	0.0032966266244144763	0.04499312351147334	0.07466673851013184	0.2858532110850016
540	100	3.821864406779661	45.365	2.305	\N	\N	\N	3.778278932733051	3.80419921875	3.75634765625	2026-04-24 13:01:02.185159	4	0.009643814765800866	0.24422067432080286	0.1750739574432373	2.3650574843088785
541	100	1.1141379310344828	28.435	0.485	\N	\N	\N	2.8282849542025863	2.841796875	2.6865234375	2026-04-24 13:01:02.736932	7	0.0032308361893993312	0.032128510555978554	0.07105576197306315	0.2506312370300293
542	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 13:01:03.159643	2	\N	\N	\N	\N
262	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-20 14:30:47.127173	2	\N	\N	\N	\N
543	100	6.28728813559322	63.515	1.165	\N	\N	\N	0.526027873411017	0.57763671875	0.50732421875	2026-04-24 13:01:03.620073	3	0.014150137982126009	0.24363174438476562	5.036519606908162	1.243041721979777
544	100	2.6831896551724137	23.49	1.445	\N	\N	\N	2.7665767346398304	2.78369140625	2.693359375	2026-04-24 13:01:04.071772	1	0.030940047280263092	0.25548462075702216	1.1285352071126302	4.93972209294637
545	100	0.9586440677966102	1.995	0.825	\N	\N	\N	2.6016452595338984	2.6240234375	2.591796875	2026-04-24 13:01:04.37947	6	0	0.03676053181029202	0.1692265510559082	0.3966176509857178
546	100	1.6392372881355932	33.59	0.86	\N	\N	\N	2.162150754766949	2.205078125	1.986328125	2026-04-24 13:01:04.607661	5	0.004394179896304482	0.0465030492816055	0.0706559658050537	0.3476482709248861
589	100	2.4388135593220337	3.965	2.285	\N	\N	\N	3.8536728681144066	3.89453125	3.8251953125	2026-04-24 20:01:03.091634	4	0.00962664442547297	0.24676604303263003	0.09787491162618002	0.4587422847747803
590	100	1.1153448275862068	32.98	0.49	\N	\N	\N	2.7927835398706895	2.80517578125	2.6328125	2026-04-24 20:01:03.454649	7	3.3100580765029134e-06	0.027988275915889416	0.07037474314371744	0.23523828188578289
269	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-20 15:00:01.270933	2	\N	\N	\N	\N
591	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 20:01:04.04579	2	\N	\N	\N	\N
592	100	5.843389830508475	47.27	1.165	\N	\N	\N	0.5365631620762712	0.55908203125	0.5146484375	2026-04-24 20:01:04.586107	3	0.007832961001638638	0.11349135269552975	5.268026622136434	1.1560813268025716
593	100	2.6044642857142857	27.98	1.48	\N	\N	\N	2.7129411368534484	2.73046875	2.61083984375	2026-04-24 20:01:05.014122	1	0.02626070248878608	0.216763923935971	1.1121681531270344	5.19723801612854
594	100	0.9598305084745763	1.59	0.82	\N	\N	\N	2.6043763241525424	2.6416015625	2.57958984375	2026-04-24 20:01:05.423812	6	0	0.0363264274597168	0.1454465389251709	0.25246971448262534
595	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 20:01:05.901177	5	\N	\N	\N	\N
638	100	7.546525423728814	21.84	2.25	\N	\N	\N	3.76756157309322	3.78955078125	3.71533203125	2026-04-25 12:00:01.501162	4	0.06834496433452024	0.23910811100975943	0.6771039644877116	13.93011401494344
639	100	1.139310344827586	28.365	0.515	\N	\N	\N	2.9657192887931036	2.98046875	2.86328125	2026-04-25 12:00:01.84476	7	0.010098739397727836	0.028047067351260425	0.07605716387430826	0.43852009773254397
640	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 12:00:02.069838	2	\N	\N	\N	\N
641	100	1.223728813559322	1.63	1.135	\N	\N	\N	0.9188708289194916	0.94580078125	0.9052734375	2026-04-25 12:00:02.536395	3	0.00544658143641585	0.049489744800632285	0.07666052182515462	0.2738879362742106
642	100	2.1822272727272725	35.165	1.435	\N	\N	\N	2.936481344288793	2.9501953125	2.77490234375	2026-04-25 12:00:02.924597	1	0.008756686065156581	0.17001416675115036	0.07915604909261068	0.3215449015299479
643	100	0.9996610169491524	2.295	0.895	\N	\N	\N	2.6006659383827686	2.61767578125	2.576171875	2026-04-25 12:00:03.240749	6	3.704087487582503e-05	0.03795719409811086	0.37497294743855797	0.9444222450256348
644	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 12:00:03.572806	5	\N	\N	\N	\N
283	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-20 17:00:04.025895	2	\N	\N	\N	\N
680	100	2.313898305084746	3.44	2.22	\N	\N	\N	3.8820428363347457	3.8984375	3.85986328125	2026-04-25 18:00:02.277922	4	0.0006399429450600834	0.19008424969042761	0.08330642382303874	0.32377055486043294
681	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 18:00:02.703131	5	\N	\N	\N	\N
682	100	1.1370689655172415	25.355	0.525	\N	\N	\N	2.8879478717672415	2.90185546875	2.79931640625	2026-04-25 18:00:03.728224	7	0	0.03442799875291727	0.07080111503601075	0.23596870104471843
683	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 18:00:03.970668	2	\N	\N	\N	\N
684	100	1.223728813559322	1.755	1.13	\N	\N	\N	0.9029147907838984	0.92822265625	0.88818359375	2026-04-25 18:00:04.213884	3	0.0013437111094846566	0.051234039856215656	0.08166006406148275	0.27594470977783203
685	100	2.133275862068966	36.945	1.44	\N	\N	\N	2.8721944518008473	2.89892578125	2.77587890625	2026-04-25 18:00:04.543923	1	0.011061729657447944	0.1814784735340183	0.07536288897196451	0.32111212412516277
290	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-20 19:00:28.769914	2	\N	\N	\N	\N
686	100	0.9588135593220339	1.575	0.865	\N	\N	\N	2.594618975105932	2.61376953125	2.5810546875	2026-04-25 18:00:04.834677	6	0	0.036781913857710985	0.15012176831563315	0.40756897926330565
715	100	2.3501694915254236	3.545	2.225	\N	\N	\N	4.248295153601695	4.26416015625	4.22509765625	2026-04-26 12:00:07.181596	4	0.0004976190146753343	0.1844473062935522	0.09146666526794434	0.3220787207285563
716	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 12:00:07.68089	5	\N	\N	\N	\N
717	100	1.1397413793103448	22.065	0.52	\N	\N	\N	3.009900323275862	3.025390625	2.9208984375	2026-04-26 12:00:08.110587	7	0.00012357760283906582	0.027697348028926524	0.07645875612894694	0.2342656930287679
718	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 12:00:08.477423	2	\N	\N	\N	\N
719	100	1.3583050847457627	1.83	1.255	\N	\N	\N	0.9664327330508474	0.994140625	0.94873046875	2026-04-26 12:00:08.727159	3	2.5375172243279925e-05	0.048731336431988216	0.08010079065958658	0.2758288860321045
297	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 08:00:03.93927	2	\N	\N	\N	\N
720	100	2.1468103448275864	29.145	1.46	\N	\N	\N	2.946628376588983	2.962890625	2.744140625	2026-04-26 12:00:09.092898	1	0.008599018323219429	0.16994796364994372	0.07909077008565267	0.32173566818237304
721	100	0.9693220338983051	1.42	0.88	\N	\N	\N	2.5743842690677967	2.5947265625	2.564453125	2026-04-26 12:00:09.421193	6	3.7037421917093214e-05	0.037129806217394375	0.16729369163513183	0.23686418533325196
742	100	0.9685593220338983	1.57	0.835	\N	\N	\N	2.5936258606991527	2.615234375	2.57421875	2026-04-26 15:01:04.993788	6	0	0.03690549171577066	0.1703753153483073	0.2385348637898763
748	100	2.16135593220339	31.345	1.485	\N	\N	\N	2.9011520127118646	2.91796875	2.7099609375	2026-04-26 16:01:06.093896	1	0.008724980273489225	0.1750982711274745	0.07352299690246582	0.3198448499043783
749	100	0.9802542372881357	1.365	0.89	\N	\N	\N	2.5747153072033897	2.6015625	2.5625	2026-04-26 16:01:06.864913	6	0	0.03704086205054974	0.19415903091430664	0.38409620920817056
750	100	2.333083333333333	3.55	2.225	\N	\N	\N	4.271378580729166	4.28759765625	4.259765625	2026-04-26 16:03:21.069925	4	0.00020178969701131186	0.18765395259857176	0.07930474281311035	0.3178751786549886
751	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 16:03:21.528377	5	\N	\N	\N	\N
752	100	1.1325	23.625	0.51	\N	\N	\N	2.9850990032327585	3.00390625	2.89111328125	2026-04-26 16:03:22.096553	7	3.4200054104045284e-05	0.026375679242408884	0.07056342760721843	0.235026216506958
753	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 16:03:22.529064	2	\N	\N	\N	\N
754	100	1.3808333333333331	2.28	1.225	\N	\N	\N	0.977294921875	0.99609375	0.94482421875	2026-04-26 16:03:23.139714	3	0.0002104913393656413	0.06375688171386719	0.07366668383280436	0.2751495202382406
755	100	2.1519166666666667	31.345	1.485	\N	\N	\N	2.9013020833333334	2.91796875	2.7099609375	2026-04-26 16:03:23.570323	1	0.008688060919443767	0.1748444005648295	0.07382515271504721	0.3202857494354248
756	100	0.9803333333333334	1.365	0.89	\N	\N	\N	2.574446614583333	2.6015625	2.5625	2026-04-26 16:03:23.863347	6	0	0.03671278285980225	0.1943509578704834	0.3842246850331624
428	100	4.9166949152542365	13.385	2.31	\N	\N	\N	3.8520425052966103	3.87939453125	3.80615234375	2026-04-22 15:01:02.197725	4	0.09167632830345024	0.3706195939597437	1.3429434339878923	6.935692399235095
429	100	1.1130172413793105	24.405	0.48	\N	\N	\N	2.701458108836207	2.72412109375	2.62060546875	2026-04-22 15:01:02.994142	7	9.928719472076932e-06	0.042249944816201424	0.0758793830871582	3.4296345392862957
304	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 10:00:05.754724	2	\N	\N	\N	\N
430	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 15:01:03.51809	2	\N	\N	\N	\N
431	100	1.22	1.72	1.135	\N	\N	\N	0.781589314088983	0.80859375	0.7666015625	2026-04-22 15:01:03.939567	3	0.00011585203267760196	0.047901171668101164	0.07881571451822916	0.17996250788370768
432	100	2.1172033898305083	33.03	1.385	\N	\N	\N	2.8395871954449152	2.8505859375	2.73974609375	2026-04-22 15:01:04.456707	1	0.008900343523187153	0.17491745948791504	0.07867592175801595	0.32132178942362466
433	100	1.2459322033898306	7.14	0.825	\N	\N	\N	2.6171792240466103	2.64453125	2.501953125	2026-04-22 15:01:04.737784	6	8.107519986336692e-05	0.038452301192701904	3.4794163703918457	0.44006121953328453
434	100	1.7405932203389831	39.645	0.93	\N	\N	\N	2.1521865068855934	2.18701171875	2.06591796875	2026-04-22 15:01:05.052082	5	0.005119447379276671	0.044857727083666574	0.0750417709350586	0.2944671154022217
505	100	3.1936440677966105	10.1	2.33	\N	\N	\N	3.792083222987288	3.81640625	3.767578125	2026-04-23 14:00:00.761907	4	0.010155356294017728	0.25766598232721877	0.23235184351603191	2.457067537307739
311	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 11:00:03.853287	2	\N	\N	\N	\N
506	100	1.0864406779661016	20.45	0.47	\N	\N	\N	2.8974361096398304	2.9130859375	2.8134765625	2026-04-23 14:00:01.025946	7	0.0005252286943338685	0.026603583319712496	0.07158648173014323	0.3800862948099772
507	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-23 14:00:01.610172	2	\N	\N	\N	\N
508	100	2.9866949152542372	30.82	1.235	\N	\N	\N	0.890236030190678	0.93115234375	0.86328125	2026-04-23 14:00:01.794405	3	0.008209960096973484	0.12010444333997825	0.7131335417429606	0.7815866311391194
509	100	2.270669642857143	28.975	1.41	\N	\N	\N	2.849920864762931	2.86962890625	2.7548828125	2026-04-23 14:00:02.034601	1	0.011662564520108498	0.2202230253057965	0.31450206438700357	0.8745092233022054
510	100	0.997457627118644	2.195	0.83	\N	\N	\N	2.6027542372881354	2.6337890625	2.583984375	2026-04-23 14:00:02.412114	6	0	0.03681778759791934	0.2988741715749105	0.3019812266031901
511	100	1.8839265536723164	28.355	1.04	\N	\N	\N	2.111088122351695	2.1572265625	2.02587890625	2026-04-23 14:00:03.328871	5	0.003411129773673365	0.045439311189854406	0.08063885370890299	0.3957753340403239
318	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 12:00:03.914359	2	\N	\N	\N	\N
547	100	6.759745762711864	22	2.295	\N	\N	\N	3.8319650423728815	3.9091796875	3.75439453125	2026-04-24 14:00:01.312598	4	0.015069940049769514	0.2947630033654682	0.5238358497619628	4.235297393798828
548	100	1.0749152542372882	28.985	0.465	\N	\N	\N	2.8223814883474576	2.884765625	2.6669921875	2026-04-24 14:00:02.062638	7	3.420280197919425e-05	0.02797441741167489	0.07005443572998046	0.23527188301086427
549	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 14:00:02.593956	2	\N	\N	\N	\N
550	100	3.7335593220338983	25.5	1.18	\N	\N	\N	0.5158070709745762	0.53369140625	0.50390625	2026-04-24 14:00:03.091714	3	0.003992994599423166	0.1487480608083434	5.020187600453695	1.0724805196126301
551	100	2.6176608187134507	24.735	1.43	\N	\N	\N	2.7570884967672415	2.77880859375	2.681640625	2026-04-24 14:00:03.456739	1	0.024050515546637063	0.21148932909561416	0.9552162965138753	4.959013843536377
552	100	0.9561016949152542	1.59	0.84	\N	\N	\N	2.5999735169491527	2.61572265625	2.587890625	2026-04-24 14:00:03.967232	6	0	0.03658856786530593	0.14208877881368	0.24212136268615722
325	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 13:44:24.896004	2	\N	\N	\N	\N
553	100	1.6633050847457629	34.28	0.875	\N	\N	\N	2.1481561175847457	2.19189453125	1.9912109375	2026-04-24 14:00:04.571706	5	0.004362272394114527	0.04522475703009244	0.07011299133300782	0.2860039552052816
596	100	2.4202542372881353	3.935	2.295	\N	\N	\N	3.904743776483051	3.927734375	3.8828125	2026-04-24 21:00:01.531427	4	0.010057912923521914	0.23981339293011164	0.10277167956034343	0.4623263359069824
645	100	2.9294067796610173	8.72	2.235	\N	\N	\N	3.7877714512711864	3.8046875	3.7685546875	2026-04-25 13:01:02.790015	4	0.0818972550408315	0.23246221008947343	0.11938110987345378	1.1776453971862793
646	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 13:01:03.140152	5	\N	\N	\N	\N
647	100	1.1315517241379311	27.895	0.515	\N	\N	\N	2.890667093211207	2.9052734375	2.7548828125	2026-04-25 13:01:03.553938	7	4.1930150177519204e-05	0.02912561222658319	0.07098495165506999	0.23617563247680665
648	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 13:01:04.029258	2	\N	\N	\N	\N
332	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 14:00:03.482958	2	\N	\N	\N	\N
649	100	1.224406779661017	1.655	1.14	\N	\N	\N	0.9165618379237288	0.93359375	0.9013671875	2026-04-25 13:01:04.488447	3	0.0006288452471716929	0.049637827954049835	0.07966047922770182	0.2749877611796061
650	100	1.8651785714285716	19.1825	1.46	\N	\N	\N	2.926509533898305	2.93994140625	2.73974609375	2026-04-25 13:01:04.79747	1	0.008722176470998991	0.1786593613382113	0.07819401423136393	0.3213184833526611
651	100	1.0200847457627118	3.865	0.8	\N	\N	\N	2.5873278601694913	2.61083984375	2.572265625	2026-04-25 13:01:05.021171	6	0	0.0757414712744244	0.1468790054321289	0.2581348896026611
687	100	2.3032203389830506	3.43	2.205	\N	\N	\N	3.8858746027542375	3.91064453125	3.86669921875	2026-04-25 19:00:02.482568	4	0.0006498773219221728	0.1912935171288959	0.08997101783752441	0.32491358121236164
688	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 19:00:03.120255	5	\N	\N	\N	\N
689	100	1.1375862068965519	24.79	0.515	\N	\N	\N	2.880926724137931	2.8935546875	2.7822265625	2026-04-25 19:00:04.019069	7	0.000217365329548464	0.026877336178795768	0.07092270851135254	0.23624567985534667
339	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-21 15:34:45.686714	2	\N	\N	\N	\N
690	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 19:00:04.533062	2	\N	\N	\N	\N
691	100	1.2135593220338983	1.645	1.13	\N	\N	\N	0.9064237950211864	0.92724609375	0.8857421875	2026-04-25 19:00:04.94471	3	0.00014122316392801575	0.04993652715521344	0.08013990720113119	0.27607682545979817
692	100	2.1760714285714284	37.055	1.445	\N	\N	\N	2.860730401400862	2.87841796875	2.75732421875	2026-04-25 19:00:05.559671	1	0.008649421950518075	0.18154029862355378	0.0801515261332194	0.32199864387512206
693	100	0.9677118644067796	1.385	0.78	\N	\N	\N	2.6011073225635593	2.62890625	2.5732421875	2026-04-25 19:00:06.004449	6	0	0.0371675163402892	0.14261212348937988	0.23851499557495118
69	100	1.8480508474576272	34.125	1.035	3527.1725862068965	204507.75	0	2.128078654661017	2.16650390625	1.9765625	2026-04-16 13:00:02.95319	5	0.19503378868103027	\N	\N	\N
70	100	2.6005172413793107	36.645	1.46	54467.969830508475	1850567.81	0	2.7678429555084745	2.8076171875	2.6923828125	2026-04-16 13:00:03.114577	1	1.7648389911651612	\N	\N	\N
71	100	1.4183050847457628	4.45	1.125	751.995593220339	11058.96	0	0.8761420815677966	0.90283203125	0.85595703125	2026-04-16 14:00:01.918804	3	0.010546646118164062	\N	\N	\N
72	100	2.461016949152542	7.685	2.21	864.21	4027.48	68.26	3.9861377780720337	4.001953125	3.96826171875	2026-04-16 14:00:02.378746	4	0.0038409042358398438	\N	\N	\N
73	100	0.8883898305084745	1.605	0.795	0	0	0	2.6159543829449152	2.62939453125	2.603515625	2026-04-16 14:00:02.736112	6	0	\N	\N	\N
74	100	1.0919827586206896	31.865	0.465	0	0	0	2.9924148033405173	3.01416015625	2.8203125	2026-04-16 14:00:02.901661	7	0	\N	\N	\N
76	100	1.9001694915254237	35	1.075	3600.754310344828	208570.73	0	2.1107157044491527	2.1455078125	1.95263671875	2026-04-16 14:00:03.493939	5	0.19890854835510255	\N	\N	\N
77	100	2.2225	36.305	1.44	13932.788983050848	758892.96	0	2.7549164870689653	2.779296875	2.65234375	2026-04-16 14:00:03.648252	1	0.7237367248535156	\N	\N	\N
78	100	5.323559322033898	50.08	1.17	8952.376101694914	456050.24	0	0.8039178363347458	0.8310546875	0.783203125	2026-04-16 17:00:00.592199	3	0.43492340087890624	\N	\N	\N
79	100	2.5827966101694915	9.69	2.205	10698.930169491525	542641.84	204.75	3.98728813559322	4.00439453125	3.96484375	2026-04-16 17:00:01.050242	4	0.5175035858154297	\N	\N	\N
80	100	0.9488983050847457	5.19	0.75	0	0	0	2.6297255693855934	2.66162109375	2.609375	2026-04-16 17:00:01.373598	6	0	\N	\N	\N
81	100	1.083793103448276	33.385	0.455	40.49254237288135	1160.48	0	2.8809183054956895	2.89794921875	2.7265625	2026-04-16 17:00:01.758919	7	0.001106719970703125	\N	\N	\N
83	100	1.7966101694915255	36.825	0.975	3907.21775862069	223274.18	0	2.071868379237288	2.10302734375	1.90625	2026-04-16 17:00:02.591447	5	0.212930850982666	\N	\N	\N
84	100	2.6763793103448275	34.6	1.42	60299.65322033899	930533.68	0	2.724146349676724	2.75	2.654296875	2026-04-16 17:00:05.262415	1	0.8874260711669922	\N	\N	\N
85	100	2.1029166666666668	42.305	1.15	6994.333166666667	304361.59	0	0.7767496744791667	0.7998046875	0.75634765625	2026-04-16 18:19:30.992802	3	0.29026183128356936	\N	\N	\N
86	100	2.346166666666667	4.965	2.19	10016.874333333333	543401.44	273.01	3.982071940104167	3.9990234375	3.96484375	2026-04-16 18:19:31.27897	4	0.5182279968261718	\N	\N	\N
722	100	2.3477966101694916	3.545	2.22	\N	\N	\N	4.254253840042373	4.26904296875	4.23974609375	2026-04-26 13:00:01.44357	4	0.0003376100831112619	0.1820685486874338	0.09060571988423666	0.3218320528666178
723	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 13:00:01.840464	5	\N	\N	\N	\N
724	100	1.1428448275862069	22.65	0.525	\N	\N	\N	3.0014816810344827	3.01318359375	2.912109375	2026-04-26 13:00:02.184976	7	1.4344554836467162e-05	0.028994879965054787	0.0706474781036377	0.23444077173868816
725	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 13:00:02.688106	2	\N	\N	\N	\N
726	100	1.4015254237288135	1.88	1.295	\N	\N	\N	0.971729343220339	0.99365234375	0.951171875	2026-04-26 13:00:05.633856	3	0.00039713520114704716	0.04845047724449029	0.07654325167338054	0.2749923229217529
320	100	2.1939655172413794	26.68	1.435	9024.805254237288	525501.26	0	2.9145425052966103	2.93359375	2.833984375	2026-04-21 12:00:04.868464	1	0.5011570549011231	\N	\N	\N
321	100	0.9126271186440678	1.58	0.81	0	0	0	2.610897775423729	2.6357421875	2.5908203125	2026-04-21 12:00:05.448424	6	0	\N	\N	\N
322	100	1.880593220338983	26.065	1.065	1879.4005172413795	86548.83	0	2.143513307733051	2.1748046875	2.06298828125	2026-04-21 12:00:05.822244	5	0.08253939628601074	\N	\N	\N
323	100	2.483166666666667	5.05	2.26	9742.665500000001	535073.99	68.25	3.9237874348958335	3.95166015625	3.892578125	2026-04-21 13:44:24.209416	4	0.5102863216400146	\N	\N	\N
324	100	1.063050847457627	34.16	0.45	72.80966666666667	2184.26	0	2.8770193326271185	2.8974609375	2.75146484375	2026-04-21 13:44:24.566645	7	0.002083072662353516	\N	\N	\N
326	100	1.2682499999999999	1.705	1.105	137.67116666666666	4027.12	0	0.8328857421875	0.85595703125	0.8173828125	2026-04-21 13:44:25.327345	3	0.0038405609130859374	\N	\N	\N
327	100	2.1316949152542373	27.775	1.43	12073.799	530326.55	0	2.880110677083333	2.8984375	2.79052734375	2026-04-21 13:44:25.496253	1	0.505758810043335	\N	\N	\N
328	100	0.9789166666666667	4.595	0.81	6.940508474576271	409.49	0	2.6070991128177967	2.62353515625	2.57958984375	2026-04-21 13:44:25.889907	6	0.0003905200958251953	\N	\N	\N
329	100	1.8854166666666667	28.19	1.045	1963.33	89354.03	0	2.1082112630208334	2.1455078125	2.0419921875	2026-04-21 13:44:26.145818	5	0.08521464347839355	\N	\N	\N
330	100	2.4777118644067797	5.05	2.25	9876.58	535073.99	68.25	3.9252267611228815	3.95166015625	3.89013671875	2026-04-21 14:00:02.639413	4	0.5102863216400146	\N	\N	\N
331	100	1.0699137931034481	34.16	0.45	61.31728813559322	2184.26	0	2.87158203125	2.8955078125	2.75146484375	2026-04-21 14:00:03.146079	7	0.002083072662353516	\N	\N	\N
333	100	1.2480508474576273	1.7	1.12	135.3757627118644	4027.12	0	0.8347954184322034	0.85595703125	0.8173828125	2026-04-21 14:00:04.531486	3	0.0038405609130859374	\N	\N	\N
334	100	2.1274137931034485	27.775	1.43	12262.23	530326.55	0	2.8757034560381354	2.8916015625	2.79052734375	2026-04-21 14:00:04.919622	1	0.505758810043335	\N	\N	\N
335	100	0.9203389830508474	1.465	0.805	2.353793103448276	68.26	0	2.6101777674788136	2.62353515625	2.60205078125	2026-04-21 14:00:05.844164	6	6.509780883789063e-05	\N	\N	\N
336	100	1.888220338983051	28.19	1.06	1893.6212068965517	89354.03	0	2.1046659825211864	2.1455078125	2.0419921875	2026-04-21 14:00:06.113656	5	0.08521464347839355	\N	\N	\N
337	100	4.124083333333333	65.07	2.245	10479.949333333332	532686.61	0	3.8009440104166665	3.826171875	3.77197265625	2026-04-21 15:34:44.712978	4	0.5080095386505127	\N	\N	\N
338	100	1.0702500000000001	34.03	0.465	9.1015	546.09	0	2.8656819661458335	2.89599609375	2.74365234375	2026-04-21 15:34:45.204058	7	0.0005207920074462891	\N	\N	\N
340	100	1.2674166666666666	1.695	1.125	167.23783333333333	4368.8	0	0.834521484375	0.85498046875	0.81787109375	2026-04-21 15:34:45.948739	3	0.004166412353515625	\N	\N	\N
341	100	1.6720689655172414	9.815	1.435	9058.954333333331	525312.2	0	2.857771809895833	2.8681640625	2.7021484375	2026-04-21 15:34:46.181091	1	0.5009767532348632	\N	\N	\N
342	100	0.9105000000000001	1.525	0.8	0	0	0	2.612548828125	2.63671875	2.599609375	2026-04-21 15:34:46.563875	6	0	\N	\N	\N
343	100	1.8409166666666665	29.42	1.04	5075.1379661016945	184213.11	0	2.0645263671875	2.08984375	1.9072265625	2026-04-21 15:34:47.02031	5	0.17567931175231932	\N	\N	\N
435	100	4.828135593220339	15.97	2.335	\N	\N	\N	3.8371788930084745	3.86865234375	3.79296875	2026-04-22 16:00:02.07975	4	0.009604717998181361	0.2550678953073793	0.3308942159016927	5.750021251042684
436	100	1.1078448275862067	24.915	0.48	\N	\N	\N	2.696112271012931	2.72314453125	2.6064453125	2026-04-22 16:00:02.739174	7	0	0.028676766864324018	0.07093440691630046	0.5213460127512614
437	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-22 16:00:03.138076	2	\N	\N	\N	\N
438	100	1.2567796610169493	2.625	1.125	\N	\N	\N	0.785106594279661	0.80908203125	0.76611328125	2026-04-22 16:00:04.345871	3	0.011830042176327462	0.0665430658954685	0.08597141901652018	0.18553657531738282
439	100	2.13093567251462	33.04	1.35	\N	\N	\N	2.812188510237069	2.84228515625	2.70947265625	2026-04-22 16:00:04.853346	1	0.014808599019454697	0.17896393581972284	0.07852587699890137	0.3286241372426351
440	100	0.9783898305084746	3.17	0.78	\N	\N	\N	2.633193193855932	2.6513671875	2.5595703125	2026-04-22 16:00:05.377045	6	0.000471397432787665	0.0376281973411297	0.4391826311747233	0.2406916618347168
441	100	1.7333050847457627	38.91	0.935	\N	\N	\N	2.14357123940678	2.1767578125	2.06103515625	2026-04-22 16:00:05.741859	5	0.00272885667866674	0.04404151094370875	0.07056344350179036	0.28121034304300946
554	100	4.881525423728814	19.275	2.31	\N	\N	\N	3.746184785487288	3.78076171875	3.70849609375	2026-04-24 15:00:01.635089	4	0.01086467920723608	0.266307898699227	0.3430142879486084	4.0015275796254475
555	100	1.1062931034482757	29.81	0.465	\N	\N	\N	2.8031721443965516	2.890625	2.55419921875	2026-04-24 15:00:02.26304	7	0.0001180553436279297	0.036650300753318654	0.07569899559020996	3.2737446308135985
556	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 15:00:02.815148	2	\N	\N	\N	\N
557	100	5.316525423728813	38.66	1.165	\N	\N	\N	0.5316555217161016	0.576171875	0.501953125	2026-04-24 15:00:03.280091	3	0.014094487206410553	0.2705892218573619	2.192087157567342	1.0209393183390298
558	100	2.538859649122807	25.59	1.455	\N	\N	\N	2.744945860745614	2.76416015625	2.6650390625	2026-04-24 15:00:03.83469	1	0.03418154781147585	0.277614998736624	0.873539924621582	2.22812876701355
559	100	1.2045762711864407	7.1	0.825	\N	\N	\N	2.6031266551906778	2.6337890625	2.5302734375	2026-04-24 15:00:04.275334	6	2.0202603833428745e-05	0.03638275046097605	3.2989740053812664	0.35848849614461265
560	100	1.6477118644067796	35.155	0.84	\N	\N	\N	2.122252383474576	2.16357421875	1.9814453125	2026-04-24 15:00:04.818072	5	0.007637413593760707	0.04569038273995383	0.07496574719746908	0.2864079793294271
597	100	1.1128448275862068	33.65	0.49	\N	\N	\N	2.809191473599138	2.87255859375	2.57763671875	2026-04-24 21:00:02.429053	7	0	0.02835754927942308	0.07082646687825521	0.2351587136586507
598	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 21:00:03.318937	2	\N	\N	\N	\N
599	100	1.7801694915254238	7.13	1.17	\N	\N	\N	0.5395838850635594	0.56494140625	0.52392578125	2026-04-24 21:00:03.715066	3	0.015604787438602769	0.07219947249202405	1.2544556935628255	0.4700756231943766
600	100	2.266594827586207	28.49	1.46	\N	\N	\N	2.7083719544491527	2.72900390625	2.59130859375	2026-04-24 21:00:04.215189	1	0.026536940881761454	0.18154469473887297	0.2765941619873047	1.4235627810160318
601	100	0.9494067796610169	1.515	0.785	\N	\N	\N	2.6143571239406778	2.638671875	2.595703125	2026-04-24 21:00:04.753912	6	0	0.03794277358473393	0.1437341849009196	0.3013149261474609
602	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-24 21:00:05.322139	5	\N	\N	\N	\N
652	100	2.5390677966101696	11.765	2.205	\N	\N	\N	3.7996308924788136	3.83544921875	3.77880859375	2026-04-25 14:00:02.97151	4	0.0018213433734441207	0.1955298735731739	0.0976853052775065	0.5294744809468587
653	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 14:00:03.703623	5	\N	\N	\N	\N
654	100	1.1326724137931037	27.475	0.515	\N	\N	\N	2.8968295393318964	2.91845703125	2.779296875	2026-04-25 14:00:04.192125	7	0.00010592331320552503	0.02589391029487222	0.07081012725830078	0.23606176376342775
655	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 14:00:04.889798	2	\N	\N	\N	\N
656	100	1.2216101694915256	1.65	1.135	\N	\N	\N	0.9179604740466102	0.9462890625	0.89990234375	2026-04-25 14:00:05.486281	3	0.0008274424278129966	0.05179366483526715	0.146554962793986	0.27720743815104165
657	100	2.1703508771929823	36.23	1.46	\N	\N	\N	2.9209646451271185	2.9345703125	2.75439453125	2026-04-25 14:00:05.951623	1	0.008712515426894366	0.17445772332660223	0.08133330345153808	0.3864957332611084
658	100	0.9702542372881355	1.59	0.82	\N	\N	\N	2.588527873411017	2.60888671875	2.57421875	2026-04-25 14:00:06.29947	6	1.6835311363483296e-05	0.03685747459016997	0.1463096300760905	0.25760931968688966
694	100	2.293305084745763	3.4	2.2	\N	\N	\N	3.9236212261652543	3.951171875	3.892578125	2026-04-25 20:00:01.543929	4	0.0006355220988645392	0.1907737347231073	0.09152339299519857	0.3248660723368327
695	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 20:00:02.112793	5	\N	\N	\N	\N
696	100	1.1374137931034483	24.26	0.51	\N	\N	\N	2.8841847386853448	2.90576171875	2.80810546875	2026-04-25 20:00:02.686291	7	4.1930473456948485e-05	0.02664111202046023	0.07070120175679524	0.23615050315856934
697	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-25 20:00:03.102329	2	\N	\N	\N	\N
698	100	1.212542372881356	1.605	1.125	\N	\N	\N	0.9009947695974576	0.92138671875	0.88330078125	2026-04-25 20:00:03.544378	3	5.185305061986891e-05	0.04998360100439039	0.08235324223836263	0.27700537045796714
699	100	2.1676867816091954	36.975	1.44	\N	\N	\N	2.8502631753177967	2.8740234375	2.74755859375	2026-04-25 20:00:04.01631	1	0.008732528201604294	0.18354321512125304	0.08071538607279459	0.32228789329528806
700	100	0.9702542372881355	1.595	0.8	\N	\N	\N	2.5909527277542375	2.619140625	2.57470703125	2026-04-25 20:00:04.371325	6	0	0.03683619778731773	0.1697508653004964	0.27378822962443033
727	100	2.147543103448276	29.78	1.445	\N	\N	\N	2.937317929025424	2.95361328125	2.70849609375	2026-04-26 13:00:07.176489	1	0.008600294953685696	0.1723446197833045	0.07500840822855631	0.3204748312632243
728	100	0.9759322033898304	1.58	0.885	\N	\N	\N	2.5826436705508473	2.6044921875	2.5732421875	2026-04-26 13:00:07.895009	6	0	0.038039750724003236	0.16719414393107096	0.23603477478027343
743	100	2.334915254237288	3.585	2.225	\N	\N	\N	4.270814022775424	4.28759765625	4.25439453125	2026-04-26 16:01:03.317324	4	0.00019969358282574153	0.1888601590819278	0.07946782112121582	0.3179848512013753
744	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 16:01:03.784638	5	\N	\N	\N	\N
745	100	1.133448275862069	23.625	0.51	\N	\N	\N	2.984997979525862	3.00390625	2.89111328125	2026-04-26 16:01:04.635364	7	3.4200054104045284e-05	0.02642192743592343	0.07056132952372234	0.2350078582763672
757	100	2.335677966101695	3.55	2.225	\N	\N	\N	4.275448556673729	4.2900390625	4.2587890625	2026-04-26 16:40:08.849336	4	0.0002030102681305449	0.1893839432021319	0.07941101392110189	0.3188120524088542
758	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 16:40:09.361442	5	\N	\N	\N	\N
759	100	1.10864406779661	24.7	0.51	\N	\N	\N	2.9810894465042375	3.00390625	2.8876953125	2026-04-26 16:40:09.844449	7	0.0011674323324429787	0.02622991998316878	0.07062962849934896	0.23545565605163574
760	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 16:40:10.282673	2	\N	\N	\N	\N
761	100	1.3455084745762713	2.28	1.2	\N	\N	\N	0.9812135858050848	1.00390625	0.94482421875	2026-04-26 16:40:10.57495	3	0.000393886727801824	0.06410342135671843	0.07360056241353354	0.2751018047332764
762	100	2.1748245614035087	31.85	1.455	\N	\N	\N	2.8986112950211864	2.912109375	2.68701171875	2026-04-26 16:40:11.019239	1	0.008965505826271186	0.17290635561538956	0.07361477216084798	0.319728946685791
763	100	0.9728813559322034	1.56	0.885	\N	\N	\N	2.571578720868644	2.59521484375	2.5625	2026-04-26 16:40:11.531159	6	0	0.036398743925423464	0.19378272692362467	0.25913864771525064
764	100	2.335169491525424	3.55	2.21	\N	\N	\N	4.275465108580509	4.2900390625	4.2587890625	2026-04-26 17:00:01.115325	4	0.0002063227508027675	0.18946700128458316	0.079520050684611	0.31856346130371094
765	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 17:00:01.5081	5	\N	\N	\N	\N
766	100	1.1304310344827586	24.7	0.515	\N	\N	\N	2.9755943561422415	2.9951171875	2.8876953125	2026-04-26 17:00:01.844576	7	0.0011674323324429787	0.026566322779251358	0.07095076243082682	0.2367589314778646
767	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 17:00:02.428354	2	\N	\N	\N	\N
768	100	1.2911864406779663	1.705	1.2	\N	\N	\N	0.9839777542372882	1.00390625	0.96630859375	2026-04-26 17:00:02.80015	3	0.0001952748379464877	0.04870636293443582	0.07363163630167643	0.27390460968017577
769	100	2.190909090909091	31.85	1.455	\N	\N	\N	2.8982522898706895	2.912109375	2.68701171875	2026-04-26 17:00:03.163975	1	0.008938873581967113	0.16913915407859673	0.0738033135732015	0.3200299580891927
770	100	0.9645762711864407	1.56	0.885	\N	\N	\N	2.57666015625	2.59765625	2.564453125	2026-04-26 17:00:03.931099	6	0	0.03656023222824623	0.17290525436401366	0.2529658158620199
771	100	2.3328813559322032	3.58	2.205	\N	\N	\N	4.28174655720339	4.296875	4.26513671875	2026-04-26 18:00:01.271979	4	0.00019638805066124866	0.19211238311508952	0.08374950091044107	0.3196687698364258
772	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 18:00:01.702389	5	\N	\N	\N	\N
773	100	1.1346551724137932	25.17	0.51	\N	\N	\N	2.9689436287715516	2.986328125	2.8837890625	2026-04-26 18:00:02.123572	7	0	0.03473540031303794	0.07053564389546713	0.23436498641967773
774	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 18:00:02.658436	2	\N	\N	\N	\N
775	100	1.325	1.69	1.175	\N	\N	\N	0.9839694782838984	1.00390625	0.966796875	2026-04-26 18:00:03.140352	3	5.5162947056657175e-05	0.04911018145286431	0.07568895022074382	0.27516353925069176
776	100	2.183	32.28	1.44	\N	\N	\N	2.8943712957974137	2.90625	2.72998046875	2026-04-26 18:00:03.672853	1	0.008604637242979923	0.17913733142917437	0.07414712905883789	0.3201804478963216
777	100	0.9717796610169491	1.61	0.91	\N	\N	\N	2.5734159825211864	2.58837890625	2.56103515625	2026-04-26 18:00:04.078448	6	0	0.03739738932827062	0.1678781032562256	0.23830122947692872
778	100	2.314406779661017	3.61	2.21	\N	\N	\N	4.285346596927966	4.30078125	4.2724609375	2026-04-26 19:00:02.757295	4	0.0002769284329171908	0.19238219406645177	0.08285163243611654	0.3199933369954427
779	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 19:00:03.123485	5	\N	\N	\N	\N
780	100	1.182155172413793	25.815	0.52	\N	\N	\N	2.9634546740301726	2.986328125	2.87548828125	2026-04-26 19:00:03.501823	7	0.08338534484475346	0.0642085616871462	0.07161870002746581	0.23474920590718587
781	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 19:00:03.91264	2	\N	\N	\N	\N
782	100	1.3475423728813558	1.665	1.215	\N	\N	\N	0.9830508474576272	0.9990234375	0.9658203125	2026-04-26 19:00:04.473731	3	1.2134616657838983e-05	0.04921600665076305	0.07778293291727702	0.2751485347747803
783	100	2.183640350877193	32.81	1.46	\N	\N	\N	2.8879104872881354	2.90576171875	2.67236328125	2026-04-26 19:00:05.006799	1	0.008526296130681442	0.17584082086207503	0.07665982246398925	0.32077689170837403
784	100	0.9545762711864407	1.6	0.75	\N	\N	\N	2.576221530720339	2.59326171875	2.56689453125	2026-04-26 19:00:05.331657	6	0	0.03726612419917666	0.1740368684132894	0.26294817924499514
785	100	2.296271186440678	3.585	2.19	\N	\N	\N	4.290394928495763	4.3046875	4.27783203125	2026-04-26 20:00:01.611375	4	0.00021403975405935515	0.1866894044714459	0.09833815892537436	0.3259629567464193
786	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 20:00:02.095756	5	\N	\N	\N	\N
787	100	1.129655172413793	26.33	0.515	\N	\N	\N	2.9585297683189653	2.97265625	2.8603515625	2026-04-26 20:00:03.735203	7	0.000665354324599444	0.027326682624170335	0.07067399024963379	0.2344879945119222
788	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 20:00:04.571136	2	\N	\N	\N	\N
789	100	1.355	1.735	1.215	\N	\N	\N	0.9814866922669492	1.00244140625	0.9658203125	2026-04-26 20:00:05.171896	3	1.2137202893273304e-05	0.04889769053055069	0.08053633371988932	0.277843713760376
790	100	2.166465517241379	33.38	1.46	\N	\N	\N	2.8711274245689653	2.88525390625	2.65673828125	2026-04-26 20:00:05.872407	1	0.008562365548085359	0.17989279359073962	0.08441297213236491	0.32370729446411134
791	100	0.9677966101694916	1.31	0.78	\N	\N	\N	2.581145722987288	2.60107421875	2.56396484375	2026-04-26 20:00:06.21228	6	0	0.037141555484972506	0.17238596280415852	0.2664925734202067
792	100	2.2825423728813563	3.955	2.16	\N	\N	\N	4.288069385593221	4.3037109375	4.26953125	2026-04-26 21:01:02.907939	4	0.00031444113133317333	0.186079418214701	0.08293134371439616	0.3192929744720459
793	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 21:01:03.316443	5	\N	\N	\N	\N
794	100	1.1332758620689656	27.045	0.51	\N	\N	\N	2.9177414466594827	2.9599609375	2.71826171875	2026-04-26 21:01:03.803582	7	0.0048589935949293235	0.028060137861866064	0.07057065963745117	0.2347703774770101
795	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 21:01:04.564498	2	\N	\N	\N	\N
796	100	1.3105932203389832	1.715	1.18	\N	\N	\N	0.9814287605932204	1.00048828125	0.96875	2026-04-26 21:01:04.974464	3	0.0019738793777207197	0.04907016899626134	0.07585787773132324	0.2765025774637858
797	100	2.166578947368421	33.965	1.455	\N	\N	\N	2.8656047952586206	2.87744140625	2.68212890625	2026-04-26 21:01:05.489348	1	0.00863330970376225	0.1728325022681285	0.0760124683380127	0.3206745465596517
798	100	0.9815254237288135	1.605	0.88	\N	\N	\N	2.5789360434322033	2.59521484375	2.55419921875	2026-04-26 21:01:05.795338	6	0	0.036527259391650815	0.17392611503601074	0.4115478038787842
799	100	2.3063559322033895	4.185	2.175	\N	\N	\N	4.249213784427966	4.2919921875	4.2265625	2026-04-26 22:00:01.780332	4	0.0004358058864787474	0.18851057634515278	0.09311823844909668	0.3220733483632406
800	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 22:00:02.038651	5	\N	\N	\N	\N
801	100	1.1296610169491526	27.37	0.515	\N	\N	\N	2.8918332891949152	2.908203125	2.70703125	2026-04-26 22:00:02.387634	7	1.7653966354111496e-05	0.02692557464211674	0.07088314692179362	0.23447723388671876
802	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-26 22:00:03.024177	2	\N	\N	\N	\N
803	100	1.3459322033898304	1.79	1.185	\N	\N	\N	0.979243908898305	0.99951171875	0.966796875	2026-04-26 22:00:03.332706	3	6.509457604359773e-05	0.04858567690445205	0.08236034711201985	0.278214963277181
804	100	2.1979848484848485	34.37	1.45	\N	\N	\N	2.8693763469827585	2.88232421875	2.677734375	2026-04-26 22:00:03.948321	1	0.008577291036056261	0.17600329350616972	0.07939208348592122	0.32219320933024087
805	100	0.8726271186440678	1.52	0.8	\N	\N	\N	2.570850436970339	2.58837890625	2.5537109375	2026-04-26 22:00:04.539138	6	0	0.03738952620276089	0.17774230639139812	0.261386775970459
806	100	3.60975	16.375	2.22	\N	\N	\N	3.779736328125	3.86865234375	3.740234375	2026-04-27 10:07:46.948744	4	0.0007876941363016765	0.19804124291737873	0.2556559403737386	3.4318485101064047
807	100	1.5966949152542373	27.355	0.965	\N	\N	\N	2.1813261387711864	2.2109375	2.10009765625	2026-04-27 10:07:52.755829	5	0.0007041269938151041	0.0796754078945871	0.0733500321706136	0.27276237805684406
808	100	1.0857627118644069	20	0.47	\N	\N	\N	2.930217161016949	2.955078125	2.83544921875	2026-04-27 10:07:57.045571	7	1.952934265136719e-05	0.02942436138788859	0.07149197260538737	0.23735539118448892
809	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-27 10:07:58.721061	2	\N	\N	\N	\N
810	100	1.3411666666666666	1.72	1.16	\N	\N	\N	1.0095540364583333	1.02490234375	0.99609375	2026-04-27 10:08:00.052285	3	9.22260284423828e-05	0.048788494110107425	0.07901328404744466	0.2779169241587321
811	100	2.1592241379310346	32.02	1.415	\N	\N	\N	2.937061374470339	2.9560546875	2.7001953125	2026-04-27 10:08:01.400213	1	0.008574892464330642	0.17420774540658723	0.07678869565327963	0.3184811592102051
812	100	0.9546610169491526	4	0.83	\N	\N	\N	2.585631289724576	2.60107421875	2.560546875	2026-04-27 10:08:03.508382	6	0	0.07452965368304336	0.18483764330546062	0.5661485195159912
813	100	3.1079661016949154	10.735	2.225	\N	\N	\N	3.892379502118644	3.92578125	3.8603515625	2026-04-27 11:00:02.21401	4	0.001084541870375811	0.19744454335358183	0.15989246368408203	1.1179889837900798
814	100	1.7774137931034484	27.355	0.975	\N	\N	\N	2.1676740975215516	2.19677734375	2.10009765625	2026-04-27 11:00:03.136197	5	0.000964294853857008	0.045906460487236414	0.07258183161417643	0.27420625686645506
815	100	1.1030172413793102	19.455	0.47	\N	\N	\N	2.914508688038793	2.927734375	2.83544921875	2026-04-27 11:00:04.123829	7	1.9859216981014964e-05	0.027856725919044624	0.07142165501912436	0.2507512887318929
816	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-04-27 11:00:04.615111	2	\N	\N	\N	\N
817	100	1.369915254237288	1.765	1.27	\N	\N	\N	1.010444253177966	1.03515625	0.9912109375	2026-04-27 11:00:05.270569	3	2.5375495522709216e-05	0.049307988215300996	0.08039720853169759	0.27922032674153646
818	100	2.140762711864407	32.525	1.46	\N	\N	\N	2.939502780720339	2.95556640625	2.7861328125	2026-04-27 11:00:05.524658	1	0.008818259158376921	0.17587539462719934	0.07811409632364909	0.3188936233520508
819	100	0.9067796610169492	1.535	0.805	\N	\N	\N	2.582080905720339	2.599609375	2.56103515625	2026-04-27 11:00:06.616191	6	0.0032862900043356003	0.0402988338470459	0.19721574783325196	0.6018751939137776
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.reservations (reservation_id, display_name, expiry_date_time, purchase_date_time, synced_at, vm_type) FROM stdin;
/providers/microsoft.capacity/reservationOrders/bda2d549-578a-4ae8-a108-852071f3afea/reservations/f9259656-5a00-4470-9097-2efd0b85fb41	Takwinland_LTRMS-Reservation	2026-06-16 12:10:18.8114+00	2025-06-16 12:10:20.608298+00	2026-04-05 14:31:34.897747	D2ls v5
/providers/microsoft.capacity/reservationOrders/c98c4076-8744-44fa-a378-5708fb79d3ac/reservations/2c346ef6-237c-44fe-835a-42c0c1320292	PAP-Reservation	2026-06-16 12:36:38.653523+00	2025-06-16 12:36:39.825412+00	2026-04-05 14:31:34.90942	D2s v5
\.


--
-- Data for Name: scheduler_config; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.scheduler_config (task_name, cron_expression, last_execution, last_status) FROM stdin;
cost	0 0 1 * * *	\N	NEVER_RUN
monthlyCost	0 0 4 9 * *	\N	NEVER_RUN
alert	0 */15 * * * *	2026-04-27 11:45:09.161462	SUCCESS
invoice	0 0 0 10 * *	\N	NEVER_RUN
infra	0 0 */6 * * *	2026-04-26 18:01:19.049973	SUCCESS
performance	0 0 * * * *	2026-04-27 11:00:06.62191	SUCCESS
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.tags (id, key, value) FROM stdin;
1	Partner	Sindibadgroup
2	Customer	LEONI
3	Product	LTRMS
4	Country	Tunisia
5	Product	PAP
6	Country	Serbia
7	Product	Takwinland
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.users (id, email, otp_code, otp_expiry, password, role) FROM stdin;
1	znaidi2049@gmail.com	960061	2026-04-26 16:45:50.873968	$2a$10$DKVgpaIOIfK1LcqndP9MNeGlm7.MfN0Dc927eT4AyyyldhZmhvvq.	SUPER_ADMIN
3	vegasznaidi@gmail.com	\N	\N	$2a$10$4bF1UOmREWyfHqz0H5yzOenIgD3npEQq4eVtbd62Kyn592P4GSc.G	MANAGER
\.


--
-- Data for Name: vm_tag; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.vm_tag (vm_id, tag_id) FROM stdin;
1	1
1	2
1	3
1	4
2	1
2	2
2	3
3	1
3	2
3	3
3	4
4	1
4	2
4	5
4	4
5	6
5	2
5	1
5	5
6	1
6	2
6	7
6	4
7	1
7	2
7	7
7	4
\.


--
-- Data for Name: vms; Type: TABLE DATA; Schema: public; Owner: znaidi
--

COPY public.vms (id, azure_vm_id, name, region, resource_group, status, vm_type, billing_type, domain_name, public_ip_address) FROM stdin;
4	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/RG-LEONI-PROD/providers/Microsoft.Compute/virtualMachines/PAP	PAP	westeurope	RG-LEONI-PROD	PowerState/running	D2s v5	RESERVATION	\N	20.126.205.54
5	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/RG-LEONI-PROD/providers/Microsoft.Compute/virtualMachines/PAP-Serbia	PAP-Serbia	westeurope	RG-LEONI-PROD	PowerState/deallocated	D2ls v5	PAYG	\N	20.101.6.225
7	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/RG-LEONI-PROD/providers/Microsoft.Compute/virtualMachines/Takwinland-db	Takwinland-db	westeurope	RG-LEONI-PROD	PowerState/running	D2ls v5	RESERVATION	\N	\N
2	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/RG-LEONI-PROD/providers/Microsoft.Compute/virtualMachines/LTRMS-Externe	LTRMS-Externe	westeurope	RG-LEONI-PROD	PowerState/deallocated	D2ls v5	PAYG	\N	20.67.40.175
3	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/RG-LEONI-PROD/providers/Microsoft.Compute/virtualMachines/LTRMS-Interne	LTRMS-Interne	westeurope	RG-LEONI-PROD	PowerState/running	D2ls v5	RESERVATION	\N	20.31.133.245
1	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/RG-LEONI-PROD/providers/Microsoft.Compute/virtualMachines/LTRMS-db	LTRMS-db	westeurope	RG-LEONI-PROD	PowerState/running	D2ls v5	RESERVATION	\N	\N
6	/subscriptions/04540351-ef95-4772-8bed-1626650bf9ed/resourceGroups/RG-LEONI-PROD/providers/Microsoft.Compute/virtualMachines/Takwinland	Takwinland	westeurope	RG-LEONI-PROD	PowerState/running	D2ls v5	RESERVATION	\N	20.76.140.129
\.


--
-- Name: azure_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.azure_alerts_id_seq', 223, true);


--
-- Name: blacklisted_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.blacklisted_tokens_id_seq', 1, false);


--
-- Name: cost_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.cost_records_id_seq', 61, true);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.invoices_id_seq', 27, true);


--
-- Name: monthly_costs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.monthly_costs_id_seq', 8042, true);


--
-- Name: monthly_vm_costs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.monthly_vm_costs_id_seq', 105, true);


--
-- Name: performance_metrics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.performance_metrics_id_seq', 819, true);


--
-- Name: tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.tags_id_seq', 7, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: vms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: znaidi
--

SELECT pg_catalog.setval('public.vms_id_seq', 7, true);


--
-- Name: azure_alerts azure_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.azure_alerts
    ADD CONSTRAINT azure_alerts_pkey PRIMARY KEY (id);


--
-- Name: blacklisted_tokens blacklisted_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.blacklisted_tokens
    ADD CONSTRAINT blacklisted_tokens_pkey PRIMARY KEY (id);


--
-- Name: cost_records cost_records_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.cost_records
    ADD CONSTRAINT cost_records_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: monthly_costs monthly_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.monthly_costs
    ADD CONSTRAINT monthly_costs_pkey PRIMARY KEY (id);


--
-- Name: monthly_vm_costs monthly_vm_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.monthly_vm_costs
    ADD CONSTRAINT monthly_vm_costs_pkey PRIMARY KEY (id);


--
-- Name: performance_metrics performance_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.performance_metrics
    ADD CONSTRAINT performance_metrics_pkey PRIMARY KEY (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (reservation_id);


--
-- Name: scheduler_config scheduler_config_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.scheduler_config
    ADD CONSTRAINT scheduler_config_pkey PRIMARY KEY (task_name);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: monthly_vm_costs uk4cpgv5v47a70dlnsdkw7d8971; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.monthly_vm_costs
    ADD CONSTRAINT uk4cpgv5v47a70dlnsdkw7d8971 UNIQUE (vm_id, month, year);


--
-- Name: azure_alerts uk4ty1qrpf73j2x6k840km0ku6r; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.azure_alerts
    ADD CONSTRAINT uk4ty1qrpf73j2x6k840km0ku6r UNIQUE (azure_alert_id, vm_id);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: blacklisted_tokens uk_ibvoggbe8ijw4l7xyyotp5n7g; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.blacklisted_tokens
    ADD CONSTRAINT uk_ibvoggbe8ijw4l7xyyotp5n7g UNIQUE (token);


--
-- Name: vms uk_jwnrnw3uqody3fqtsdg77crif; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.vms
    ADD CONSTRAINT uk_jwnrnw3uqody3fqtsdg77crif UNIQUE (azure_vm_id);


--
-- Name: azure_alerts uk_os8vfemgu3jxdgaon4gagagvb; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.azure_alerts
    ADD CONSTRAINT uk_os8vfemgu3jxdgaon4gagagvb UNIQUE (azure_alert_id);


--
-- Name: invoices uklog1sjo7h0ql92g6cqmbn7sr8; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT uklog1sjo7h0ql92g6cqmbn7sr8 UNIQUE (invoice_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vms vms_pkey; Type: CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.vms
    ADD CONSTRAINT vms_pkey PRIMARY KEY (id);


--
-- Name: idx_is_shared; Type: INDEX; Schema: public; Owner: znaidi
--

CREATE INDEX idx_is_shared ON public.monthly_costs USING btree (is_shared);


--
-- Name: idx_month_year; Type: INDEX; Schema: public; Owner: znaidi
--

CREATE INDEX idx_month_year ON public.monthly_costs USING btree (month, year);


--
-- Name: idx_service_month; Type: INDEX; Schema: public; Owner: znaidi
--

CREATE INDEX idx_service_month ON public.monthly_costs USING btree (service_name, month, year);


--
-- Name: idx_vm_id; Type: INDEX; Schema: public; Owner: znaidi
--

CREATE INDEX idx_vm_id ON public.monthly_costs USING btree (vm_id);


--
-- Name: vm_tag fkcbea4kpqmtsyh3g870lut2ajf; Type: FK CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.vm_tag
    ADD CONSTRAINT fkcbea4kpqmtsyh3g870lut2ajf FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: performance_metrics fkfx7419m7bjwji0sdb363owp2g; Type: FK CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.performance_metrics
    ADD CONSTRAINT fkfx7419m7bjwji0sdb363owp2g FOREIGN KEY (vm_id) REFERENCES public.vms(id);


--
-- Name: vm_tag fkg26j2tpgs8au6oonqy4uyouxy; Type: FK CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.vm_tag
    ADD CONSTRAINT fkg26j2tpgs8au6oonqy4uyouxy FOREIGN KEY (vm_id) REFERENCES public.vms(id);


--
-- Name: monthly_vm_costs fkgtxt0p3bch1hbhkmqvtlwbpxl; Type: FK CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.monthly_vm_costs
    ADD CONSTRAINT fkgtxt0p3bch1hbhkmqvtlwbpxl FOREIGN KEY (vm_id) REFERENCES public.vms(id);


--
-- Name: azure_alerts fklko17mmbfmed3ghjj13q57j70; Type: FK CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.azure_alerts
    ADD CONSTRAINT fklko17mmbfmed3ghjj13q57j70 FOREIGN KEY (vm_id) REFERENCES public.vms(id);


--
-- Name: cost_records fknsawardrvt3pfg8yim10uys9q; Type: FK CONSTRAINT; Schema: public; Owner: znaidi
--

ALTER TABLE ONLY public.cost_records
    ADD CONSTRAINT fknsawardrvt3pfg8yim10uys9q FOREIGN KEY (vm_id) REFERENCES public.vms(id);


--
-- PostgreSQL database dump complete
--

\unrestrict tHvl6KMbFPHyqDJof8WkDv4QZRkcfyIiMEJ0KYJ0VKhoX7R0nqw4qWwfa7M0Tbg

