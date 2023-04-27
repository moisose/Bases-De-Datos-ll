USE [db01]
GO

ALTER DATABASE [db01] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [db01].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [db01] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [db01] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [db01] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [db01] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [db01] SET ARITHABORT OFF 
GO
ALTER DATABASE [db01] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [db01] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [db01] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [db01] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [db01] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [db01] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [db01] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [db01] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [db01] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [db01] SET  DISABLE_BROKER 
GO
ALTER DATABASE [db01] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [db01] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [db01] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [db01] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [db01] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [db01] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [db01] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [db01] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [db01] SET  MULTI_USER 
GO
ALTER DATABASE [db01] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [db01] SET DB_CHAINING OFF 
GO
ALTER DATABASE [db01] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [db01] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [db01] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [db01] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [db01] SET QUERY_STORE = ON
GO
ALTER DATABASE [db01] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [db01]
GO
/****** Object:  Table [dbo].[Administrator]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Administrator](
	[userId] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Campus]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Campus](
	[campusId] [int] IDENTITY(1,1) NOT NULL,
	[campusName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[campusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CampusXUser]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CampusXUser](
	[campusXUserId] [int] IDENTITY(1,1) NOT NULL,
	[campusId] [int] NOT NULL,
	[userId] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[campusXUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Career]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Career](
	[careerId] [int] IDENTITY(1,1) NOT NULL,
	[careerName] [varchar](50) NOT NULL,
	[description] [varchar](50) NOT NULL,
	[facultyId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[careerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CareerPlan]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CareerPlan](
	[planId] [int] IDENTITY(1,1) NOT NULL,
	[careerId] [int] NOT NULL,
	[creationDate] [date] NOT NULL,
	[activationDate] [date] NOT NULL,
	[endingDate] [date] NOT NULL,
	[statusId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[planId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CareerXFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CareerXFile](
	[careerXFileId] [int] IDENTITY(1,1) NOT NULL,
	[careerId] [int] NOT NULL,
	[fileId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[careerXFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CareerXUser]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CareerXUser](
	[careerXUserId] [int] IDENTITY(1,1) NOT NULL,
	[careerId] [int] NOT NULL,
	[userId] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[careerXUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[courseId] [int] IDENTITY(1,1) NOT NULL,
	[courseName] [varchar](50) NOT NULL,
	[facultyId] [int] NOT NULL,
	[credits] [int] NOT NULL,
	[hoursPerWeek] [int] NOT NULL,
	[description] [varchar](100) NOT NULL,
	[periodTypeId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[courseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseEvaluation]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseEvaluation](
	[courseEvaluationId] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](200) NOT NULL,
	[courseGroupId] [int] NOT NULL,
	[score] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[courseEvaluationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseGroup]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseGroup](
	[courseGroupId] [int] IDENTITY(1,1) NOT NULL,
	[courseId] [int] NOT NULL,
	[periodId] [int] NOT NULL,
	[professorId] [varchar](32) NOT NULL,
	[maxStudents] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[courseGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseGroupXFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseGroupXFile](
	[courseGroupXFileId] [int] IDENTITY(1,1) NOT NULL,
	[courseGroupId] [int] NOT NULL,
	[fileId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[courseGroupXFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseRequirement]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseRequirement](
	[courseRequirementId] [int] IDENTITY(1,1) NOT NULL,
	[courseId] [int] NOT NULL,
	[courseXPlanId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[courseRequirementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseXFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseXFile](
	[CourseXFileId] [int] IDENTITY(1,1) NOT NULL,
	[courseId] [int] NOT NULL,
	[fileId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CourseXFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseXPlan]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseXPlan](
	[courseXPlanId] [int] IDENTITY(1,1) NOT NULL,
	[planId] [int] NOT NULL,
	[courseId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[courseXPlanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Day_]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Day_](
	[dayId] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[dayId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Enrollment]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrollment](
	[enrollmentId] [int] IDENTITY(1,1) NOT NULL,
	[periodId] [int] NOT NULL,
	[statusId] [int] NOT NULL,
	[startDate] [date] NOT NULL,
	[endingDate] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[enrollmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnrollmentStatus]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnrollmentStatus](
	[statusId] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[statusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EnrollmentXStudent]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnrollmentXStudent](
	[enrollmentXStudentId] [int] IDENTITY(1,1) NOT NULL,
	[enrollmentTime] [time](7) NOT NULL,
	[userId] [varchar](32) NOT NULL,
	[enrollmentId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[enrollmentXStudentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Evaluation]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Evaluation](
	[evaluationId] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](100) NOT NULL,
	[deadline] [date] NOT NULL,
	[totalValue] [float] NOT NULL,
	[evaluationTypeId] [int] NOT NULL,
	[courseGroupId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[evaluationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EvaluationType]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EvaluationType](
	[evaluationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[evaluationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Faculty]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Faculty](
	[facultyId] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[facultyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[File_]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[File_](
	[fileId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [varchar](32) NOT NULL,
	[fileTypeId] [int] NOT NULL,
	[periodId] [int] NOT NULL,
	[creationDate] [date] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[fileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileType]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileType](
	[fileTypeId] [int] IDENTITY(1,1) NOT NULL,
	[fileTypeName] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[fileTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Item]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item](
	[itemId] [int] IDENTITY(1,1) NOT NULL,
	[evaluationId] [int] NOT NULL,
	[description] [varchar](100) NOT NULL,
	[itemValue] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[itemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PeriodStatus]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeriodStatus](
	[statusId] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[statusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PeriodType]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeriodType](
	[periodTypeId] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[periodTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanStatus]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanStatus](
	[statusId] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[statusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Professor]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Professor](
	[userId] [varchar](32) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProfessorXFaculty]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProfessorXFaculty](
	[professorXFacultyId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [varchar](32) NOT NULL,
	[facultyId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[professorXFacultyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schedule](
	[scheduleId] [int] IDENTITY(1,1) NOT NULL,
	[startTime] [time](7) NOT NULL,
	[finishTime] [time](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[scheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScheduleXCourseGroup]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleXCourseGroup](
	[scheduleXCourseGroupId] [int] IDENTITY(1,1) NOT NULL,
	[scheduleXDayId] [int] NOT NULL,
	[courseGroupId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[scheduleXCourseGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScheduleXDay]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleXDay](
	[scheduleXDayId] [int] IDENTITY(1,1) NOT NULL,
	[scheduleId] [int] NOT NULL,
	[dayId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[scheduleXDayId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SchoolPeriod]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchoolPeriod](
	[schoolPeriodId] [int] IDENTITY(1,1) NOT NULL,
	[periodTypeId] [int] NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NOT NULL,
	[statusId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[schoolPeriodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[userId] [varchar](32) NOT NULL,
	[isAssistant] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentXCourse]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentXCourse](
	[studentXCourseId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [varchar](32) NOT NULL,
	[courseId] [int] NOT NULL,
	[status] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[studentXCourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentXItem]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentXItem](
	[StudentXItemId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [varchar](32) NOT NULL,
	[itemId] [int] NOT NULL,
	[grade] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StudentXItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentXPlan]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentXPlan](
	[studentXPlanId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [varchar](32) NOT NULL,
	[planId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[studentXPlanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User_]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_](
	[userId] [varchar](32) NOT NULL,
	[userName] [varchar](50) NOT NULL,
	[birthDate] [date] NOT NULL,
	[email] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Version]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Version](
	[versionId] [int] IDENTITY(1,1) NOT NULL,
	[fileId] [int] NOT NULL,
	[modificationDate] [date] NOT NULL,
	[filename] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[versionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WeeklySchedule]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WeeklySchedule](
	[weeklyScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [varchar](32) NOT NULL,
	[courseGroupId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[weeklyScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Administrator] ([userId]) VALUES (N'GRwlFGmveoY7IxLAy4XFBY19S6j2')
GO
SET IDENTITY_INSERT [dbo].[Campus] ON 
GO
INSERT [dbo].[Campus] ([campusId], [campusName]) VALUES (1, N'Campus A')
GO
INSERT [dbo].[Campus] ([campusId], [campusName]) VALUES (2, N'Campus B')
GO
INSERT [dbo].[Campus] ([campusId], [campusName]) VALUES (3, N'Campus C')
GO
SET IDENTITY_INSERT [dbo].[Campus] OFF
GO
SET IDENTITY_INSERT [dbo].[CampusXUser] ON 
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (1, 1, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (2, 2, N'KhnwK1edmlS9l39IkLxPvNywkrC3')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (3, 1, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (4, 3, N'pSHGLHzYYqR8xdnIztuXP6toqo12')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (5, 2, N'LGCKPnHowQORw36GS5a1AV7iiNv2')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (6, 1, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (7, 3, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (8, 2, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (9, 1, N'2ZN8xDvztpeziotTb3hoXSYVVyo2')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (10, 2, N'BPAvOX11ErSIZiPIo2Dh4vSfouN2')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (11, 3, N'RAt9dz4AC0RfbG6HJRRfdtWaCXM2')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (12, 1, N'H1QG5PORkVT4aFn6tq0Rlv08pa13')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (13, 2, N'eLJQg405NZOp411ua7mYADoGGvs1')
GO
INSERT [dbo].[CampusXUser] ([campusXUserId], [campusId], [userId]) VALUES (14, 3, N'1CIV8lWhk6RzjVebjSuQ2MnXbHg1')
GO
SET IDENTITY_INSERT [dbo].[CampusXUser] OFF
GO
SET IDENTITY_INSERT [dbo].[Career] ON 
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (1, N'Systems Engineering', N'Systems engineering degree', 2)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (2, N'Civil Engineering', N'Construction degree', 2)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (3, N'Business Administration', N'Business degree', 6)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (4, N'Architecture', N'Design and construction degree', 11)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (5, N'Law', N'Law degree', 10)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (6, N'Medicine', N'Health sciences degree', 7)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (7, N'Psychology', N'Social sciences degree', 8)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (8, N'Communication', N'Media and communication degree', 3)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (9, N'Education', N'Teacher education degree', 9)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (10, N'Dentistry', N'Dentistry degree', 7)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (11, N'Environmental Engineering', N'Environmental sciences degree', 2)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (12, N'Electronic Engineering', N'Electronic engineering degree', 2)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (13, N'Art and Design', N'Art and design degree', 4)
GO
INSERT [dbo].[Career] ([careerId], [careerName], [description], [facultyId]) VALUES (14, N'Math', N'Math career', 4)
GO
SET IDENTITY_INSERT [dbo].[Career] OFF
GO
SET IDENTITY_INSERT [dbo].[CareerPlan] ON 
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (1, 1, CAST(N'2022-01-01' AS Date), CAST(N'2022-02-01' AS Date), CAST(N'2025-05-01' AS Date), 2)
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (2, 2, CAST(N'2022-02-15' AS Date), CAST(N'2022-03-01' AS Date), CAST(N'2025-06-01' AS Date), 2)
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (3, 3, CAST(N'2022-03-10' AS Date), CAST(N'2022-04-01' AS Date), CAST(N'2025-07-01' AS Date), 2)
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (4, 4, CAST(N'2022-04-05' AS Date), CAST(N'2022-05-01' AS Date), CAST(N'2025-08-01' AS Date), 2)
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (5, 5, CAST(N'2022-05-01' AS Date), CAST(N'2022-06-01' AS Date), CAST(N'2025-09-01' AS Date), 2)
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (6, 7, CAST(N'2022-05-01' AS Date), CAST(N'2022-06-01' AS Date), CAST(N'2025-09-01' AS Date), 2)
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (7, 9, CAST(N'2022-05-01' AS Date), CAST(N'2022-06-01' AS Date), CAST(N'2025-09-01' AS Date), 2)
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (8, 13, CAST(N'2022-05-01' AS Date), CAST(N'2022-06-01' AS Date), CAST(N'2025-09-01' AS Date), 2)
GO
INSERT [dbo].[CareerPlan] ([planId], [careerId], [creationDate], [activationDate], [endingDate], [statusId]) VALUES (9, 14, CAST(N'2022-05-01' AS Date), CAST(N'2022-06-01' AS Date), CAST(N'2025-09-01' AS Date), 2)
GO
SET IDENTITY_INSERT [dbo].[CareerPlan] OFF
GO
SET IDENTITY_INSERT [dbo].[CareerXUser] ON 
GO
INSERT [dbo].[CareerXUser] ([careerXUserId], [careerId], [userId]) VALUES (1, 1, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22')
GO
INSERT [dbo].[CareerXUser] ([careerXUserId], [careerId], [userId]) VALUES (2, 7, N'KhnwK1edmlS9l39IkLxPvNywkrC3')
GO
INSERT [dbo].[CareerXUser] ([careerXUserId], [careerId], [userId]) VALUES (3, 8, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2')
GO
INSERT [dbo].[CareerXUser] ([careerXUserId], [careerId], [userId]) VALUES (4, 9, N'pSHGLHzYYqR8xdnIztuXP6toqo12')
GO
INSERT [dbo].[CareerXUser] ([careerXUserId], [careerId], [userId]) VALUES (5, 13, N'LGCKPnHowQORw36GS5a1AV7iiNv2')
GO
INSERT [dbo].[CareerXUser] ([careerXUserId], [careerId], [userId]) VALUES (6, 14, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2')
GO
INSERT [dbo].[CareerXUser] ([careerXUserId], [careerId], [userId]) VALUES (7, 1, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1')
GO
INSERT [dbo].[CareerXUser] ([careerXUserId], [careerId], [userId]) VALUES (8, 14, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2')
GO
SET IDENTITY_INSERT [dbo].[CareerXUser] OFF
GO
SET IDENTITY_INSERT [dbo].[Course] ON 
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (1, N'Calculus I', 12, 4, 4, N'Introductory calculus course', 2)
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (2, N'Calculus II', 12, 4, 4, N'Calculus course with focus on integrals', 2)
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (3, N'Linear Algebra', 12, 3, 3, N'Introductory linear algebra course', 2)
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (4, N'Discrete Mathematics', 12, 3, 3, N'Course on discrete mathematics and combinatorics', 2)
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (5, N'Programming Fundamentals', 2, 4, 4, N'Introduction to programming using Java', 2)
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (6, N'Data Structures and Algorithms', 2, 4, 4, N'Course on data structures and algorithms using Java', 2)
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (7, N'Marketing Management', 4, 3, 3, N'This course covers the principles and practices of marketing management.', 2)
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (8, N'Introduction to Psychology', 8, 3, 3, N'This course covers the fundamentals of psychology.', 2)
GO
INSERT [dbo].[Course] ([courseId], [courseName], [facultyId], [credits], [hoursPerWeek], [description], [periodTypeId]) VALUES (9, N'Spanish Language and Literature', 9, 3, 3, N'This course covers the literature and language of the Spanish-speaking world.', 2)
GO
SET IDENTITY_INSERT [dbo].[Course] OFF
GO
SET IDENTITY_INSERT [dbo].[CourseEvaluation] ON 
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (1, N'The course was well-organized and informative. I found it helpful in preparing for my career.', 1, 8.7)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (2, N'The course content was engaging and the instructor was knowledgeable. Overall, it was a great learning experience.', 1, 9.1)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (3, N'The course was informative, but the pace was a bit slow for my liking. I think it could have been more challenging.', 2, 6.9)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (4, N'The course content was relevant and useful. The instructor was approachable and willing to help.', 3, 7.8)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (5, N'The course was interesting, but I think it could have gone into more depth on some topics. Overall, it was a good learning experience.', 4, 7.2)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (6, N'The course was very useful and the instructor was knowledgeable. I learned a lot and would recommend it to others.', 5, 8.4)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (7, N'The course was challenging, but the instructor was helpful and provided good feedback. I feel like I learned a lot and improved my skills.', 6, 8.1)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (8, N'The course was engaging and the instructor was approachable. I enjoyed learning about the subject and found the content relevant.', 7, 8.3)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (9, N'The course was informative and the instructor was knowledgeable. Overall, it was a good learning experience.', 8, 7.6)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (10, N'The course was very challenging, but the instructor was very helpful and provided good feedback. I learned a lot and improved my skills.', 9, 9)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (11, N'The course content was engaging and the instructor was knowledgeable. I enjoyed learning about the subject and found the assignments very helpful.', 10, 8.2)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (12, N'The course was well-structured and the instructor was approachable. I found it to be a great learning experience overall.', 11, 8.8)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (13, N'The course was informative, but the instructor was a bit disorganized at times. I think it could have been more efficient.', 12, 7.1)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (14, N'The course content was relevant and useful. The instructor was approachable and willing to help. Overall, it was a great learning experience.', 13, 9.4)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (15, N'The course was very interesting and the instructor was very knowledgeable. I learned a lot and would highly recommend it to others.', 14, 9.6)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (16, N'The course was well-designed and the instructor was very engaging. I found it to be a great learning experience overall.', 15, 8.9)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (17, N'The course was very challenging, but the instructor was very knowledgeable and supportive. I learned a lot and felt a great sense of accomplishment.', 16, 9.3)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (18, N'The course content was comprehensive and the instructor was very approachable. I found it to be a great learning experience overall.', 17, 8.5)
GO
INSERT [dbo].[CourseEvaluation] ([courseEvaluationId], [description], [courseGroupId], [score]) VALUES (19, N'The course content was very relevant and the instructor was very knowledgeable. I learned a lot and felt very engaged throughout the course.', 18, 9.2)
GO
SET IDENTITY_INSERT [dbo].[CourseEvaluation] OFF
GO
SET IDENTITY_INSERT [dbo].[CourseGroup] ON 
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (1, 1, 4, N'2ZN8xDvztpeziotTb3hoXSYVVyo2', 20)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (2, 2, 4, N'BPAvOX11ErSIZiPIo2Dh4vSfouN2', 25)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (3, 3, 4, N'RAt9dz4AC0RfbG6HJRRfdtWaCXM2', 30)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (4, 4, 4, N'H1QG5PORkVT4aFn6tq0Rlv08pa13', 18)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (5, 5, 4, N'eLJQg405NZOp411ua7mYADoGGvs1', 22)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (6, 6, 4, N'1CIV8lWhk6RzjVebjSuQ2MnXbHg1', 28)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (7, 7, 4, N'2ZN8xDvztpeziotTb3hoXSYVVyo2', 35)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (8, 8, 4, N'BPAvOX11ErSIZiPIo2Dh4vSfouN2', 15)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (9, 9, 4, N'RAt9dz4AC0RfbG6HJRRfdtWaCXM2', 20)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (10, 1, 5, N'2ZN8xDvztpeziotTb3hoXSYVVyo2', 20)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (11, 2, 5, N'BPAvOX11ErSIZiPIo2Dh4vSfouN2', 25)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (12, 3, 5, N'RAt9dz4AC0RfbG6HJRRfdtWaCXM2', 30)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (13, 4, 5, N'H1QG5PORkVT4aFn6tq0Rlv08pa13', 18)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (14, 5, 5, N'eLJQg405NZOp411ua7mYADoGGvs1', 22)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (15, 6, 5, N'1CIV8lWhk6RzjVebjSuQ2MnXbHg1', 28)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (16, 7, 5, N'2ZN8xDvztpeziotTb3hoXSYVVyo2', 35)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (17, 8, 5, N'BPAvOX11ErSIZiPIo2Dh4vSfouN2', 15)
GO
INSERT [dbo].[CourseGroup] ([courseGroupId], [courseId], [periodId], [professorId], [maxStudents]) VALUES (18, 9, 5, N'RAt9dz4AC0RfbG6HJRRfdtWaCXM2', 20)
GO
SET IDENTITY_INSERT [dbo].[CourseGroup] OFF
GO
SET IDENTITY_INSERT [dbo].[CourseRequirement] ON 
GO
INSERT [dbo].[CourseRequirement] ([courseRequirementId], [courseId], [courseXPlanId]) VALUES (1, 1, 2)
GO
INSERT [dbo].[CourseRequirement] ([courseRequirementId], [courseId], [courseXPlanId]) VALUES (2, 2, 3)
GO
INSERT [dbo].[CourseRequirement] ([courseRequirementId], [courseId], [courseXPlanId]) VALUES (3, 5, 6)
GO
SET IDENTITY_INSERT [dbo].[CourseRequirement] OFF
GO
SET IDENTITY_INSERT [dbo].[CourseXPlan] ON 
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (1, 9, 1)
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (2, 9, 2)
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (3, 9, 3)
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (4, 1, 4)
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (5, 1, 5)
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (6, 1, 6)
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (7, 8, 7)
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (8, 6, 8)
GO
INSERT [dbo].[CourseXPlan] ([courseXPlanId], [planId], [courseId]) VALUES (9, 7, 9)
GO
SET IDENTITY_INSERT [dbo].[CourseXPlan] OFF
GO
SET IDENTITY_INSERT [dbo].[Day_] ON 
GO
INSERT [dbo].[Day_] ([dayId], [name]) VALUES (1, N'Monday')
GO
INSERT [dbo].[Day_] ([dayId], [name]) VALUES (2, N'Tuesday')
GO
INSERT [dbo].[Day_] ([dayId], [name]) VALUES (3, N'Wednesday')
GO
INSERT [dbo].[Day_] ([dayId], [name]) VALUES (4, N'Thursday')
GO
INSERT [dbo].[Day_] ([dayId], [name]) VALUES (5, N'Friday')
GO
INSERT [dbo].[Day_] ([dayId], [name]) VALUES (6, N'Saturday')
GO
INSERT [dbo].[Day_] ([dayId], [name]) VALUES (7, N'Sunday')
GO
SET IDENTITY_INSERT [dbo].[Day_] OFF
GO
SET IDENTITY_INSERT [dbo].[Enrollment] ON 
GO
INSERT [dbo].[Enrollment] ([enrollmentId], [periodId], [statusId], [startDate], [endingDate]) VALUES (1, 5, 2, CAST(N'2023-06-05' AS Date), CAST(N'2023-06-06' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Enrollment] OFF
GO
SET IDENTITY_INSERT [dbo].[EnrollmentStatus] ON 
GO
INSERT [dbo].[EnrollmentStatus] ([statusId], [description]) VALUES (1, N'open')
GO
INSERT [dbo].[EnrollmentStatus] ([statusId], [description]) VALUES (2, N'closed')
GO
SET IDENTITY_INSERT [dbo].[EnrollmentStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[Evaluation] ON 
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (1, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 1)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (2, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 1)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (3, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 1)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (4, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 1)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (5, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 1)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (6, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 1)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (7, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 1)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (8, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 2)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (9, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 2)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (10, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 2)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (11, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 2)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (12, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 2)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (13, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 2)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (14, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 2)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (15, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 3)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (16, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 3)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (17, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 3)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (18, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 3)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (19, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 3)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (20, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 3)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (21, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 3)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (22, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 4)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (23, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 4)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (24, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 4)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (25, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 4)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (26, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 4)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (27, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 4)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (28, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 4)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (29, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 5)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (30, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 5)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (31, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 5)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (32, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 5)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (33, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 5)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (34, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 5)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (35, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 5)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (36, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 6)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (37, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 6)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (38, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 6)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (39, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 6)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (40, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 6)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (41, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 6)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (42, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 6)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (43, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 7)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (44, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 7)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (45, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 7)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (46, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 7)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (47, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 7)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (48, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 7)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (49, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 7)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (50, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 8)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (51, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 8)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (52, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 8)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (53, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 8)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (54, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 8)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (55, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 8)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (56, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 8)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (57, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 9)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (58, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 9)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (59, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 9)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (60, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 9)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (61, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 9)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (62, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 9)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (63, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 9)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (64, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 10)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (65, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 10)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (66, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 10)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (67, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 10)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (68, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 10)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (69, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 10)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (70, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 10)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (71, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 11)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (72, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 11)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (73, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 11)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (74, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 11)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (75, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 11)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (76, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 11)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (77, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 11)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (78, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 12)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (79, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 12)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (80, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 12)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (81, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 12)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (82, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 12)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (83, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 12)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (84, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 12)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (85, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 13)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (86, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 13)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (87, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 13)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (88, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 13)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (89, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 13)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (90, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 13)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (91, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 13)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (92, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 14)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (93, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 14)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (94, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 14)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (95, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 14)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (96, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 14)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (97, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 14)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (98, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 14)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (99, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 15)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (100, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 15)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (101, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 15)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (102, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 15)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (103, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 15)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (104, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 15)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (105, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 15)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (106, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 16)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (107, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 16)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (108, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 16)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (109, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 16)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (110, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 16)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (111, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 16)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (112, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 16)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (113, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 17)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (114, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 17)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (115, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 17)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (116, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 17)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (117, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 17)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (118, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 17)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (119, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 17)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (120, N'Exam', CAST(N'2023-03-10' AS Date), 25, 1, 18)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (121, N'Exam', CAST(N'2023-04-15' AS Date), 25, 1, 18)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (122, N'Exam', CAST(N'2023-05-23' AS Date), 25, 1, 18)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (123, N'Project', CAST(N'2023-04-10' AS Date), 10, 5, 18)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (124, N'Homework 1', CAST(N'2023-02-10' AS Date), 5, 3, 18)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (125, N'Homework 2', CAST(N'2023-03-07' AS Date), 5, 3, 18)
GO
INSERT [dbo].[Evaluation] ([evaluationId], [description], [deadline], [totalValue], [evaluationTypeId], [courseGroupId]) VALUES (126, N'Homework 3', CAST(N'2023-05-14' AS Date), 5, 3, 18)
GO
SET IDENTITY_INSERT [dbo].[Evaluation] OFF
GO
SET IDENTITY_INSERT [dbo].[EvaluationType] ON 
GO
INSERT [dbo].[EvaluationType] ([evaluationTypeId], [description]) VALUES (1, N'written exam')
GO
INSERT [dbo].[EvaluationType] ([evaluationTypeId], [description]) VALUES (2, N'Oral exam')
GO
INSERT [dbo].[EvaluationType] ([evaluationTypeId], [description]) VALUES (3, N'Homework')
GO
INSERT [dbo].[EvaluationType] ([evaluationTypeId], [description]) VALUES (4, N'Oral presentation')
GO
INSERT [dbo].[EvaluationType] ([evaluationTypeId], [description]) VALUES (5, N'Project')
GO
INSERT [dbo].[EvaluationType] ([evaluationTypeId], [description]) VALUES (6, N'Laboratory practice')
GO
INSERT [dbo].[EvaluationType] ([evaluationTypeId], [description]) VALUES (7, N'Essay')
GO
INSERT [dbo].[EvaluationType] ([evaluationTypeId], [description]) VALUES (8, N'Investigation')
GO
SET IDENTITY_INSERT [dbo].[EvaluationType] OFF
GO
SET IDENTITY_INSERT [dbo].[Faculty] ON 
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (1, N'Sciences')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (2, N'Engineering')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (3, N'Communication Sciences')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (4, N'Arts')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (5, N'Humanities')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (6, N'Administration')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (7, N'Medicine')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (8, N'Social Sciences')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (9, N'Education')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (10, N'Law')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (11, N'Architecture')
GO
INSERT [dbo].[Faculty] ([facultyId], [name]) VALUES (12, N'Math')
GO
SET IDENTITY_INSERT [dbo].[Faculty] OFF
GO
SET IDENTITY_INSERT [dbo].[FileType] ON 
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (1, N'json')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (2, N'bson')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (3, N'txt')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (4, N'html')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (5, N'css')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (6, N'js')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (7, N'py')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (8, N'java')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (9, N'cs')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (10, N'php')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (11, N'sql')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (12, N'xml')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (13, N'yaml')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (14, N'pdf')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (15, N'doc')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (16, N'xls')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (17, N'ppt')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (18, N'jpg')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (19, N'mp3')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (20, N'mp4')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (21, N'zip')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (22, N'rar')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (23, N'tar.gz')
GO
INSERT [dbo].[FileType] ([fileTypeId], [fileTypeName]) VALUES (24, N'other')
GO
SET IDENTITY_INSERT [dbo].[FileType] OFF
GO
SET IDENTITY_INSERT [dbo].[Item] ON 
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (1, 1, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (2, 1, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (3, 1, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (4, 1, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (5, 2, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (6, 2, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (7, 2, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (8, 2, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (9, 3, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (10, 3, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (11, 3, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (12, 3, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (13, 4, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (14, 4, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (15, 4, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (16, 5, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (17, 6, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (18, 7, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (19, 8, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (20, 8, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (21, 8, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (22, 8, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (23, 9, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (24, 9, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (25, 9, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (26, 9, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (27, 10, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (28, 10, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (29, 10, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (30, 10, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (31, 11, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (32, 11, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (33, 11, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (34, 12, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (35, 13, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (36, 14, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (37, 15, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (38, 15, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (39, 15, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (40, 15, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (41, 16, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (42, 16, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (43, 16, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (44, 16, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (45, 17, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (46, 17, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (47, 17, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (48, 17, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (49, 18, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (50, 18, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (51, 18, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (52, 19, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (53, 20, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (54, 21, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (55, 22, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (56, 22, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (57, 22, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (58, 22, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (59, 23, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (60, 23, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (61, 23, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (62, 23, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (63, 24, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (64, 24, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (65, 24, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (66, 24, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (67, 25, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (68, 25, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (69, 25, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (70, 26, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (71, 27, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (72, 28, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (73, 29, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (74, 29, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (75, 29, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (76, 29, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (77, 30, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (78, 30, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (79, 30, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (80, 30, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (81, 31, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (82, 31, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (83, 31, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (84, 31, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (85, 32, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (86, 32, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (87, 32, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (88, 33, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (89, 34, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (90, 35, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (91, 36, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (92, 36, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (93, 36, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (94, 36, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (95, 37, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (96, 37, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (97, 37, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (98, 37, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (99, 38, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (100, 38, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (101, 38, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (102, 38, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (103, 39, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (104, 39, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (105, 39, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (106, 40, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (107, 41, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (108, 42, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (109, 43, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (110, 43, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (111, 43, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (112, 43, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (113, 44, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (114, 44, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (115, 44, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (116, 44, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (117, 45, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (118, 45, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (119, 45, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (120, 45, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (121, 46, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (122, 46, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (123, 46, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (124, 47, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (125, 48, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (126, 49, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (127, 50, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (128, 50, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (129, 50, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (130, 50, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (131, 51, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (132, 51, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (133, 51, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (134, 51, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (135, 52, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (136, 52, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (137, 52, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (138, 52, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (139, 53, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (140, 53, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (141, 53, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (142, 54, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (143, 55, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (144, 56, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (145, 57, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (146, 57, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (147, 57, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (148, 57, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (149, 58, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (150, 58, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (151, 58, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (152, 58, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (153, 59, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (154, 59, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (155, 59, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (156, 59, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (157, 60, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (158, 60, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (159, 60, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (160, 61, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (161, 62, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (162, 63, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (163, 64, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (164, 64, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (165, 64, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (166, 64, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (167, 65, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (168, 65, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (169, 65, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (170, 65, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (171, 66, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (172, 66, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (173, 66, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (174, 66, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (175, 67, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (176, 67, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (177, 67, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (178, 68, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (179, 69, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (180, 70, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (181, 71, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (182, 71, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (183, 71, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (184, 71, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (185, 72, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (186, 72, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (187, 72, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (188, 72, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (189, 73, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (190, 73, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (191, 73, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (192, 73, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (193, 74, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (194, 74, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (195, 74, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (196, 75, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (197, 76, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (198, 77, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (199, 78, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (200, 78, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (201, 78, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (202, 78, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (203, 79, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (204, 79, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (205, 79, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (206, 79, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (207, 80, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (208, 80, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (209, 80, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (210, 80, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (211, 81, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (212, 81, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (213, 81, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (214, 82, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (215, 83, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (216, 84, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (217, 85, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (218, 85, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (219, 85, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (220, 85, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (221, 86, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (222, 86, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (223, 86, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (224, 86, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (225, 87, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (226, 87, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (227, 87, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (228, 87, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (229, 88, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (230, 88, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (231, 88, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (232, 89, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (233, 90, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (234, 91, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (235, 92, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (236, 92, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (237, 92, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (238, 92, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (239, 93, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (240, 93, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (241, 93, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (242, 93, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (243, 94, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (244, 94, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (245, 94, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (246, 94, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (247, 95, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (248, 95, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (249, 95, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (250, 96, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (251, 97, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (252, 98, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (253, 99, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (254, 99, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (255, 99, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (256, 99, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (257, 100, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (258, 100, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (259, 100, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (260, 100, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (261, 101, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (262, 101, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (263, 101, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (264, 101, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (265, 102, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (266, 102, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (267, 102, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (268, 103, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (269, 104, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (270, 105, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (271, 106, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (272, 106, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (273, 106, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (274, 106, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (275, 107, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (276, 107, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (277, 107, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (278, 107, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (279, 108, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (280, 108, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (281, 108, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (282, 108, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (283, 109, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (284, 109, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (285, 109, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (286, 110, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (287, 111, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (288, 112, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (289, 113, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (290, 113, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (291, 113, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (292, 113, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (293, 114, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (294, 114, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (295, 114, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (296, 114, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (297, 115, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (298, 115, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (299, 115, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (300, 115, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (301, 116, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (302, 116, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (303, 116, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (304, 117, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (305, 118, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (306, 119, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (307, 120, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (308, 120, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (309, 120, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (310, 120, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (311, 121, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (312, 121, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (313, 121, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (314, 121, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (315, 122, N'Question 1', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (316, 122, N'Question 2', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (317, 122, N'Question 3', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (318, 122, N'Question 4', 10)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (319, 123, N'Item 1', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (320, 123, N'Item 2', 3)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (321, 123, N'Item 3', 4)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (322, 124, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (323, 125, N'Exercise', 5)
GO
INSERT [dbo].[Item] ([itemId], [evaluationId], [description], [itemValue]) VALUES (324, 126, N'Exercise', 5)
GO
SET IDENTITY_INSERT [dbo].[Item] OFF
GO
SET IDENTITY_INSERT [dbo].[PeriodStatus] ON 
GO
INSERT [dbo].[PeriodStatus] ([statusId], [description]) VALUES (1, N'created')
GO
INSERT [dbo].[PeriodStatus] ([statusId], [description]) VALUES (2, N'in progress')
GO
INSERT [dbo].[PeriodStatus] ([statusId], [description]) VALUES (3, N'finalized')
GO
SET IDENTITY_INSERT [dbo].[PeriodStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[PeriodType] ON 
GO
INSERT [dbo].[PeriodType] ([periodTypeId], [description]) VALUES (1, N'annual')
GO
INSERT [dbo].[PeriodType] ([periodTypeId], [description]) VALUES (2, N'semiannual')
GO
INSERT [dbo].[PeriodType] ([periodTypeId], [description]) VALUES (3, N'quarterly')
GO
INSERT [dbo].[PeriodType] ([periodTypeId], [description]) VALUES (4, N'fourmonthly')
GO
INSERT [dbo].[PeriodType] ([periodTypeId], [description]) VALUES (5, N'bimonthly')
GO
SET IDENTITY_INSERT [dbo].[PeriodType] OFF
GO
SET IDENTITY_INSERT [dbo].[PlanStatus] ON 
GO
INSERT [dbo].[PlanStatus] ([statusId], [description]) VALUES (1, N'creation')
GO
INSERT [dbo].[PlanStatus] ([statusId], [description]) VALUES (2, N'active')
GO
INSERT [dbo].[PlanStatus] ([statusId], [description]) VALUES (3, N'closed')
GO
SET IDENTITY_INSERT [dbo].[PlanStatus] OFF
GO
INSERT [dbo].[Professor] ([userId]) VALUES (N'1CIV8lWhk6RzjVebjSuQ2MnXbHg1')
GO
INSERT [dbo].[Professor] ([userId]) VALUES (N'2ZN8xDvztpeziotTb3hoXSYVVyo2')
GO
INSERT [dbo].[Professor] ([userId]) VALUES (N'BPAvOX11ErSIZiPIo2Dh4vSfouN2')
GO
INSERT [dbo].[Professor] ([userId]) VALUES (N'eLJQg405NZOp411ua7mYADoGGvs1')
GO
INSERT [dbo].[Professor] ([userId]) VALUES (N'H1QG5PORkVT4aFn6tq0Rlv08pa13')
GO
INSERT [dbo].[Professor] ([userId]) VALUES (N'RAt9dz4AC0RfbG6HJRRfdtWaCXM2')
GO
SET IDENTITY_INSERT [dbo].[ProfessorXFaculty] ON 
GO
INSERT [dbo].[ProfessorXFaculty] ([professorXFacultyId], [userId], [facultyId]) VALUES (1, N'2ZN8xDvztpeziotTb3hoXSYVVyo2', 1)
GO
INSERT [dbo].[ProfessorXFaculty] ([professorXFacultyId], [userId], [facultyId]) VALUES (2, N'BPAvOX11ErSIZiPIo2Dh4vSfouN2', 2)
GO
INSERT [dbo].[ProfessorXFaculty] ([professorXFacultyId], [userId], [facultyId]) VALUES (3, N'RAt9dz4AC0RfbG6HJRRfdtWaCXM2', 3)
GO
INSERT [dbo].[ProfessorXFaculty] ([professorXFacultyId], [userId], [facultyId]) VALUES (4, N'H1QG5PORkVT4aFn6tq0Rlv08pa13', 4)
GO
INSERT [dbo].[ProfessorXFaculty] ([professorXFacultyId], [userId], [facultyId]) VALUES (5, N'eLJQg405NZOp411ua7mYADoGGvs1', 5)
GO
INSERT [dbo].[ProfessorXFaculty] ([professorXFacultyId], [userId], [facultyId]) VALUES (6, N'1CIV8lWhk6RzjVebjSuQ2MnXbHg1', 6)
GO
SET IDENTITY_INSERT [dbo].[ProfessorXFaculty] OFF
GO
SET IDENTITY_INSERT [dbo].[Schedule] ON 
GO
INSERT [dbo].[Schedule] ([scheduleId], [startTime], [finishTime]) VALUES (1, CAST(N'07:30:00' AS Time), CAST(N'09:20:00' AS Time))
GO
INSERT [dbo].[Schedule] ([scheduleId], [startTime], [finishTime]) VALUES (2, CAST(N'09:30:00' AS Time), CAST(N'11:20:00' AS Time))
GO
INSERT [dbo].[Schedule] ([scheduleId], [startTime], [finishTime]) VALUES (3, CAST(N'01:00:00' AS Time), CAST(N'15:20:00' AS Time))
GO
INSERT [dbo].[Schedule] ([scheduleId], [startTime], [finishTime]) VALUES (4, CAST(N'15:30:00' AS Time), CAST(N'17:20:00' AS Time))
GO
INSERT [dbo].[Schedule] ([scheduleId], [startTime], [finishTime]) VALUES (5, CAST(N'17:30:00' AS Time), CAST(N'19:20:00' AS Time))
GO
SET IDENTITY_INSERT [dbo].[Schedule] OFF
GO
SET IDENTITY_INSERT [dbo].[ScheduleXCourseGroup] ON 
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (1, 11, 1)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (2, 21, 1)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (3, 11, 2)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (4, 22, 2)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (5, 7, 3)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (6, 17, 3)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (7, 9, 4)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (8, 19, 4)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (9, 13, 5)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (10, 23, 5)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (11, 15, 6)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (12, 25, 6)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (13, 1, 7)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (14, 2, 7)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (15, 28, 8)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (16, 4, 9)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (17, 11, 10)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (18, 22, 10)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (19, 11, 11)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (20, 21, 11)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (21, 7, 12)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (22, 17, 12)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (23, 9, 13)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (24, 19, 13)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (25, 13, 14)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (26, 23, 14)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (27, 15, 15)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (28, 25, 15)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (29, 1, 16)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (30, 2, 16)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (31, 28, 17)
GO
INSERT [dbo].[ScheduleXCourseGroup] ([scheduleXCourseGroupId], [scheduleXDayId], [courseGroupId]) VALUES (32, 4, 18)
GO
SET IDENTITY_INSERT [dbo].[ScheduleXCourseGroup] OFF
GO
SET IDENTITY_INSERT [dbo].[ScheduleXDay] ON 
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (1, 1, 1)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (2, 2, 1)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (3, 3, 1)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (4, 4, 1)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (5, 5, 1)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (6, 1, 2)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (7, 2, 2)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (8, 3, 2)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (9, 4, 2)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (10, 5, 2)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (11, 1, 3)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (12, 2, 3)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (13, 3, 3)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (14, 4, 3)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (15, 5, 3)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (16, 1, 4)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (17, 2, 4)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (18, 3, 4)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (19, 4, 4)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (20, 5, 4)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (21, 1, 5)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (22, 2, 5)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (23, 3, 5)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (24, 4, 5)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (25, 5, 5)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (26, 1, 6)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (27, 2, 6)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (28, 3, 6)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (29, 4, 6)
GO
INSERT [dbo].[ScheduleXDay] ([scheduleXDayId], [scheduleId], [dayId]) VALUES (30, 5, 6)
GO
SET IDENTITY_INSERT [dbo].[ScheduleXDay] OFF
GO
SET IDENTITY_INSERT [dbo].[SchoolPeriod] ON 
GO
INSERT [dbo].[SchoolPeriod] ([schoolPeriodId], [periodTypeId], [startDate], [endDate], [statusId]) VALUES (1, 4, CAST(N'2022-02-07' AS Date), CAST(N'2022-05-15' AS Date), 3)
GO
INSERT [dbo].[SchoolPeriod] ([schoolPeriodId], [periodTypeId], [startDate], [endDate], [statusId]) VALUES (2, 5, CAST(N'2022-12-01' AS Date), CAST(N'2022-01-29' AS Date), 2)
GO
INSERT [dbo].[SchoolPeriod] ([schoolPeriodId], [periodTypeId], [startDate], [endDate], [statusId]) VALUES (3, 2, CAST(N'2022-07-01' AS Date), CAST(N'2021-11-28' AS Date), 1)
GO
INSERT [dbo].[SchoolPeriod] ([schoolPeriodId], [periodTypeId], [startDate], [endDate], [statusId]) VALUES (4, 2, CAST(N'2023-02-07' AS Date), CAST(N'2023-06-20' AS Date), 1)
GO
INSERT [dbo].[SchoolPeriod] ([schoolPeriodId], [periodTypeId], [startDate], [endDate], [statusId]) VALUES (5, 2, CAST(N'2023-06-07' AS Date), CAST(N'2023-11-24' AS Date), 1)
GO
SET IDENTITY_INSERT [dbo].[SchoolPeriod] OFF
GO
INSERT [dbo].[Student] ([userId], [isAssistant]) VALUES (N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 1)
GO
INSERT [dbo].[Student] ([userId], [isAssistant]) VALUES (N'KhnwK1edmlS9l39IkLxPvNywkrC3', 1)
GO
INSERT [dbo].[Student] ([userId], [isAssistant]) VALUES (N'LGCKPnHowQORw36GS5a1AV7iiNv2', 0)
GO
INSERT [dbo].[Student] ([userId], [isAssistant]) VALUES (N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 1)
GO
INSERT [dbo].[Student] ([userId], [isAssistant]) VALUES (N'pSHGLHzYYqR8xdnIztuXP6toqo12', 0)
GO
INSERT [dbo].[Student] ([userId], [isAssistant]) VALUES (N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 0)
GO
INSERT [dbo].[Student] ([userId], [isAssistant]) VALUES (N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 1)
GO
INSERT [dbo].[Student] ([userId], [isAssistant]) VALUES (N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 0)
GO
SET IDENTITY_INSERT [dbo].[StudentXCourse] ON 
GO
INSERT [dbo].[StudentXCourse] ([studentXCourseId], [userId], [courseId], [status]) VALUES (1, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 1, 1)
GO
INSERT [dbo].[StudentXCourse] ([studentXCourseId], [userId], [courseId], [status]) VALUES (2, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 2, 0)
GO
INSERT [dbo].[StudentXCourse] ([studentXCourseId], [userId], [courseId], [status]) VALUES (3, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 3, 1)
GO
INSERT [dbo].[StudentXCourse] ([studentXCourseId], [userId], [courseId], [status]) VALUES (4, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 4, 0)
GO
INSERT [dbo].[StudentXCourse] ([studentXCourseId], [userId], [courseId], [status]) VALUES (5, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 5, 1)
GO
INSERT [dbo].[StudentXCourse] ([studentXCourseId], [userId], [courseId], [status]) VALUES (6, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 6, 1)
GO
INSERT [dbo].[StudentXCourse] ([studentXCourseId], [userId], [courseId], [status]) VALUES (7, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 7, 0)
GO
INSERT [dbo].[StudentXCourse] ([studentXCourseId], [userId], [courseId], [status]) VALUES (8, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 8, 1)
GO
SET IDENTITY_INSERT [dbo].[StudentXCourse] OFF
GO
SET IDENTITY_INSERT [dbo].[StudentXItem] ON 
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (1, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 1, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (2, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 2, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (3, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 3, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (4, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 4, 7)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (5, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 5, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (6, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 6, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (7, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 7, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (8, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 8, 9)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (9, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 9, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (10, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 10, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (11, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 11, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (12, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 12, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (13, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 13, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (14, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 14, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (15, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 15, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (16, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 16, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (17, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 17, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (18, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 18, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (19, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 19, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (20, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 20, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (21, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 21, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (22, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 22, 8)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (23, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 23, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (24, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 24, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (25, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 25, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (26, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 26, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (27, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 27, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (28, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 28, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (29, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 29, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (30, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 30, 6)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (31, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 31, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (32, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 32, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (33, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 33, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (34, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 34, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (35, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 35, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (36, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 36, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (37, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 37, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (38, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 38, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (39, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 39, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (40, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 40, 10)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (41, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 41, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (42, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 42, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (43, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 43, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (44, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 44, 10)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (45, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 45, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (46, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 46, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (47, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 47, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (48, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 48, 10)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (49, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 49, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (50, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 50, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (51, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 51, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (52, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 52, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (53, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 53, 0)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (54, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 54, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (55, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 55, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (56, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 56, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (57, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 57, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (58, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 58, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (59, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 59, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (60, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 60, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (61, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 61, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (62, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 62, 7)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (63, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 63, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (64, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 64, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (65, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 65, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (66, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 66, 6)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (67, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 67, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (68, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 68, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (69, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 69, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (70, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 70, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (71, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 71, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (72, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 72, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (73, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 73, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (74, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 74, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (75, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 75, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (76, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 76, 8)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (77, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 77, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (78, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 78, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (79, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 79, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (80, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 80, 9)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (81, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 81, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (82, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 82, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (83, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 83, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (84, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 84, 8)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (85, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 85, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (86, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 86, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (87, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 87, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (88, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 88, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (89, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 89, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (90, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 90, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (91, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 91, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (92, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 92, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (93, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 93, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (94, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 94, 10)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (95, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 95, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (96, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 96, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (97, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 97, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (98, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 98, 9)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (99, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 99, 9)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (100, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 100, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (101, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 101, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (102, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 102, 8)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (103, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 103, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (104, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 104, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (105, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 105, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (106, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 106, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (107, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 107, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (108, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 108, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (109, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 109, 0)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (110, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 110, 1)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (111, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 111, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (112, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 112, 6)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (113, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 113, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (114, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 114, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (115, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 115, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (116, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 116, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (117, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 117, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (118, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 118, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (119, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 119, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (120, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 120, 8)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (121, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 121, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (122, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 122, 0)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (123, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 123, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (124, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 124, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (125, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 125, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (126, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 126, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (127, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 127, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (128, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 128, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (129, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 129, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (130, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 130, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (131, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 131, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (132, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 132, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (133, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 133, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (134, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 134, 8)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (135, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 135, 4)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (136, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 136, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (137, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 137, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (138, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 138, 10)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (139, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 139, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (140, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 140, 3)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (141, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 141, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (142, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 142, 5)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (143, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 143, 2)
GO
INSERT [dbo].[StudentXItem] ([StudentXItemId], [userId], [itemId], [grade]) VALUES (144, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 144, 5)
GO
SET IDENTITY_INSERT [dbo].[StudentXItem] OFF
GO
SET IDENTITY_INSERT [dbo].[StudentXPlan] ON 
GO
INSERT [dbo].[StudentXPlan] ([studentXPlanId], [userId], [planId]) VALUES (1, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 9)
GO
INSERT [dbo].[StudentXPlan] ([studentXPlanId], [userId], [planId]) VALUES (2, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 9)
GO
INSERT [dbo].[StudentXPlan] ([studentXPlanId], [userId], [planId]) VALUES (3, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 9)
GO
INSERT [dbo].[StudentXPlan] ([studentXPlanId], [userId], [planId]) VALUES (4, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 1)
GO
INSERT [dbo].[StudentXPlan] ([studentXPlanId], [userId], [planId]) VALUES (5, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 1)
GO
INSERT [dbo].[StudentXPlan] ([studentXPlanId], [userId], [planId]) VALUES (6, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 1)
GO
INSERT [dbo].[StudentXPlan] ([studentXPlanId], [userId], [planId]) VALUES (7, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 6)
GO
SET IDENTITY_INSERT [dbo].[StudentXPlan] OFF
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'1CIV8lWhk6RzjVebjSuQ2MnXbHg1', N'David Gómez', CAST(N'1997-03-30' AS Date), N'david.gomez@mail.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'2ZN8xDvztpeziotTb3hoXSYVVyo2', N'Juan Pérez', CAST(N'1990-01-01' AS Date), N'juan.perez@mail.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'BPAvOX11ErSIZiPIo2Dh4vSfouN2', N'María García', CAST(N'1995-02-15' AS Date), N'maria.garcia@mail.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'eLJQg405NZOp411ua7mYADoGGvs1', N'Luisa Fernández', CAST(N'1992-08-12' AS Date), N'luisa.fernandez@mail.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', N'Sarah Lee', CAST(N'1987-08-02' AS Date), N'sarah.lee@example.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'GRwlFGmveoY7IxLAy4XFBY19S6j2', N'Moises Solano', CAST(N'2002-03-25' AS Date), N'moisessoes@gmail.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'H1QG5PORkVT4aFn6tq0Rlv08pa13', N'Ana Torres', CAST(N'1998-12-05' AS Date), N'ana.torres@mail.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'KhnwK1edmlS9l39IkLxPvNywkrC3', N'Jane Smith', CAST(N'1995-02-28' AS Date), N'jane.smith@example.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'LGCKPnHowQORw36GS5a1AV7iiNv2', N'Michael Brown', CAST(N'1999-01-06' AS Date), N'michael.brown@example.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', N'Elizabeth Chen', CAST(N'1992-12-01' AS Date), N'elizabeth.chen@example.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'pSHGLHzYYqR8xdnIztuXP6toqo12', N'Emily Davis', CAST(N'1990-07-23' AS Date), N'emily.davis@example.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'RAt9dz4AC0RfbG6HJRRfdtWaCXM2', N'Pedro Rodríguez', CAST(N'1985-06-22' AS Date), N'pedro.rodriguez@mail.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', N'David Kim', CAST(N'1994-04-17' AS Date), N'david.kim@example.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', N'Robert Johnson', CAST(N'1982-11-15' AS Date), N'robert.johnson@example.com')
GO
INSERT [dbo].[User_] ([userId], [userName], [birthDate], [email]) VALUES (N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', N'John Doe', CAST(N'1989-05-12' AS Date), N'john.doe@example.com')
GO
SET IDENTITY_INSERT [dbo].[WeeklySchedule] ON 
GO
INSERT [dbo].[WeeklySchedule] ([weeklyScheduleId], [userId], [courseGroupId]) VALUES (1, N'VJ6npbzqvPX1Xk93EnXsWwWN9A22', 1)
GO
INSERT [dbo].[WeeklySchedule] ([weeklyScheduleId], [userId], [courseGroupId]) VALUES (2, N'KhnwK1edmlS9l39IkLxPvNywkrC3', 2)
GO
INSERT [dbo].[WeeklySchedule] ([weeklyScheduleId], [userId], [courseGroupId]) VALUES (3, N'u7lFJCTYm2dhnYunj7RTgxrHOTQ2', 3)
GO
INSERT [dbo].[WeeklySchedule] ([weeklyScheduleId], [userId], [courseGroupId]) VALUES (4, N'pSHGLHzYYqR8xdnIztuXP6toqo12', 4)
GO
INSERT [dbo].[WeeklySchedule] ([weeklyScheduleId], [userId], [courseGroupId]) VALUES (5, N'LGCKPnHowQORw36GS5a1AV7iiNv2', 5)
GO
INSERT [dbo].[WeeklySchedule] ([weeklyScheduleId], [userId], [courseGroupId]) VALUES (6, N'fFri4sRcE0P6oKHtdZ7INR2jwwl2', 6)
GO
INSERT [dbo].[WeeklySchedule] ([weeklyScheduleId], [userId], [courseGroupId]) VALUES (7, N'rYOJVmoEL6eQ1G7QTYQPPpRubvz1', 7)
GO
INSERT [dbo].[WeeklySchedule] ([weeklyScheduleId], [userId], [courseGroupId]) VALUES (8, N'mYvgqpG4lgWDzAmWEejxBDgvXYA2', 8)
GO
SET IDENTITY_INSERT [dbo].[WeeklySchedule] OFF
GO
ALTER TABLE [dbo].[Administrator]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User_] ([userId])
GO
ALTER TABLE [dbo].[CampusXUser]  WITH CHECK ADD FOREIGN KEY([campusId])
REFERENCES [dbo].[Campus] ([campusId])
GO
ALTER TABLE [dbo].[CampusXUser]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User_] ([userId])
GO
ALTER TABLE [dbo].[Career]  WITH CHECK ADD FOREIGN KEY([facultyId])
REFERENCES [dbo].[Faculty] ([facultyId])
GO
ALTER TABLE [dbo].[CareerPlan]  WITH CHECK ADD FOREIGN KEY([careerId])
REFERENCES [dbo].[Career] ([careerId])
GO
ALTER TABLE [dbo].[CareerPlan]  WITH CHECK ADD FOREIGN KEY([statusId])
REFERENCES [dbo].[PlanStatus] ([statusId])
GO
ALTER TABLE [dbo].[CareerXFile]  WITH CHECK ADD FOREIGN KEY([careerId])
REFERENCES [dbo].[Career] ([careerId])
GO
ALTER TABLE [dbo].[CareerXFile]  WITH CHECK ADD FOREIGN KEY([fileId])
REFERENCES [dbo].[File_] ([fileId])
GO
ALTER TABLE [dbo].[CareerXUser]  WITH CHECK ADD FOREIGN KEY([careerId])
REFERENCES [dbo].[Career] ([careerId])
GO
ALTER TABLE [dbo].[CareerXUser]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User_] ([userId])
GO
ALTER TABLE [dbo].[Course]  WITH CHECK ADD FOREIGN KEY([facultyId])
REFERENCES [dbo].[Faculty] ([facultyId])
GO
ALTER TABLE [dbo].[Course]  WITH CHECK ADD FOREIGN KEY([periodTypeId])
REFERENCES [dbo].[PeriodType] ([periodTypeId])
GO
ALTER TABLE [dbo].[CourseEvaluation]  WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [dbo].[CourseGroup] ([courseGroupId])
GO
ALTER TABLE [dbo].[CourseGroup]  WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [dbo].[Course] ([courseId])
GO
ALTER TABLE [dbo].[CourseGroup]  WITH CHECK ADD FOREIGN KEY([periodId])
REFERENCES [dbo].[SchoolPeriod] ([schoolPeriodId])
GO
ALTER TABLE [dbo].[CourseGroup]  WITH CHECK ADD FOREIGN KEY([professorId])
REFERENCES [dbo].[Professor] ([userId])
GO
ALTER TABLE [dbo].[CourseGroupXFile]  WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [dbo].[CourseGroup] ([courseGroupId])
GO
ALTER TABLE [dbo].[CourseGroupXFile]  WITH CHECK ADD FOREIGN KEY([fileId])
REFERENCES [dbo].[File_] ([fileId])
GO
ALTER TABLE [dbo].[CourseRequirement]  WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [dbo].[Course] ([courseId])
GO
ALTER TABLE [dbo].[CourseRequirement]  WITH CHECK ADD FOREIGN KEY([courseXPlanId])
REFERENCES [dbo].[CourseXPlan] ([courseXPlanId])
GO
ALTER TABLE [dbo].[CourseXFile]  WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [dbo].[Course] ([courseId])
GO
ALTER TABLE [dbo].[CourseXFile]  WITH CHECK ADD FOREIGN KEY([fileId])
REFERENCES [dbo].[File_] ([fileId])
GO
ALTER TABLE [dbo].[CourseXPlan]  WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [dbo].[Course] ([courseId])
GO
ALTER TABLE [dbo].[CourseXPlan]  WITH CHECK ADD FOREIGN KEY([planId])
REFERENCES [dbo].[CareerPlan] ([planId])
GO
ALTER TABLE [dbo].[Enrollment]  WITH CHECK ADD FOREIGN KEY([periodId])
REFERENCES [dbo].[SchoolPeriod] ([schoolPeriodId])
GO
ALTER TABLE [dbo].[Enrollment]  WITH CHECK ADD FOREIGN KEY([statusId])
REFERENCES [dbo].[EnrollmentStatus] ([statusId])
GO
ALTER TABLE [dbo].[EnrollmentXStudent]  WITH CHECK ADD FOREIGN KEY([enrollmentId])
REFERENCES [dbo].[Enrollment] ([enrollmentId])
GO
ALTER TABLE [dbo].[EnrollmentXStudent]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[Student] ([userId])
GO
ALTER TABLE [dbo].[Evaluation]  WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [dbo].[CourseGroup] ([courseGroupId])
GO
ALTER TABLE [dbo].[Evaluation]  WITH CHECK ADD FOREIGN KEY([evaluationTypeId])
REFERENCES [dbo].[EvaluationType] ([evaluationTypeId])
GO
ALTER TABLE [dbo].[File_]  WITH CHECK ADD FOREIGN KEY([fileTypeId])
REFERENCES [dbo].[FileType] ([fileTypeId])
GO
ALTER TABLE [dbo].[File_]  WITH CHECK ADD FOREIGN KEY([periodId])
REFERENCES [dbo].[SchoolPeriod] ([schoolPeriodId])
GO
ALTER TABLE [dbo].[File_]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User_] ([userId])
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD FOREIGN KEY([evaluationId])
REFERENCES [dbo].[Evaluation] ([evaluationId])
GO
ALTER TABLE [dbo].[Professor]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User_] ([userId])
GO
ALTER TABLE [dbo].[ProfessorXFaculty]  WITH CHECK ADD FOREIGN KEY([facultyId])
REFERENCES [dbo].[Faculty] ([facultyId])
GO
ALTER TABLE [dbo].[ProfessorXFaculty]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[Professor] ([userId])
GO
ALTER TABLE [dbo].[ScheduleXCourseGroup]  WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [dbo].[CourseGroup] ([courseGroupId])
GO
ALTER TABLE [dbo].[ScheduleXCourseGroup]  WITH CHECK ADD FOREIGN KEY([scheduleXDayId])
REFERENCES [dbo].[ScheduleXDay] ([scheduleXDayId])
GO
ALTER TABLE [dbo].[ScheduleXDay]  WITH CHECK ADD FOREIGN KEY([dayId])
REFERENCES [dbo].[Day_] ([dayId])
GO
ALTER TABLE [dbo].[ScheduleXDay]  WITH CHECK ADD FOREIGN KEY([scheduleId])
REFERENCES [dbo].[Schedule] ([scheduleId])
GO
ALTER TABLE [dbo].[SchoolPeriod]  WITH CHECK ADD FOREIGN KEY([periodTypeId])
REFERENCES [dbo].[PeriodType] ([periodTypeId])
GO
ALTER TABLE [dbo].[SchoolPeriod]  WITH CHECK ADD FOREIGN KEY([statusId])
REFERENCES [dbo].[PeriodStatus] ([statusId])
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[User_] ([userId])
GO
ALTER TABLE [dbo].[StudentXCourse]  WITH CHECK ADD FOREIGN KEY([courseId])
REFERENCES [dbo].[Course] ([courseId])
GO
ALTER TABLE [dbo].[StudentXCourse]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[Student] ([userId])
GO
ALTER TABLE [dbo].[StudentXItem]  WITH CHECK ADD FOREIGN KEY([itemId])
REFERENCES [dbo].[Item] ([itemId])
GO
ALTER TABLE [dbo].[StudentXItem]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[Student] ([userId])
GO
ALTER TABLE [dbo].[StudentXPlan]  WITH CHECK ADD FOREIGN KEY([planId])
REFERENCES [dbo].[CareerPlan] ([planId])
GO
ALTER TABLE [dbo].[StudentXPlan]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[Student] ([userId])
GO
ALTER TABLE [dbo].[Version]  WITH CHECK ADD FOREIGN KEY([fileId])
REFERENCES [dbo].[File_] ([fileId])
GO
ALTER TABLE [dbo].[WeeklySchedule]  WITH CHECK ADD FOREIGN KEY([courseGroupId])
REFERENCES [dbo].[CourseGroup] ([courseGroupId])
GO
ALTER TABLE [dbo].[WeeklySchedule]  WITH CHECK ADD FOREIGN KEY([userId])
REFERENCES [dbo].[Student] ([userId])
GO
/****** Object:  StoredProcedure [dbo].[spCreateFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- CRUD File_

-- CREATE
CREATE   PROCEDURE [dbo].[spCreateFile](@userId VARCHAR(32), @filename VARCHAR(15), @fileTypeId INT, @periodId INT, @creationDate DATE, @name VARCHAR(50), @description VARCHAR(100)) AS
BEGIN
    IF @userId IS NULL OR @filename IS NULL OR @fileTypeId IS NULL OR @periodId IS NULL OR @creationDate IS NULL OR @name IS NULL OR @description IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM File_ WHERE userId = @userId AND fileTypeId = @fileTypeId AND periodId = @periodId AND creationDate = @creationDate AND name = @name AND description = @description)
    BEGIN
        SELECT 'The file already exists' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @periodId)
    BEGIN
        SELECT 'The period does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM FileType WHERE fileTypeId = @fileTypeId)
    BEGIN
        SELECT 'The file type does not exist' AS ExecMessage
        RETURN
    END

    INSERT INTO File_ (userId, fileTypeId, periodId, creationDate, name, description) VALUES (@userId, @fileTypeId, @periodId, @creationDate, @name, @description)
    INSERT INTO Version (fileId, modificationDate, filename) VALUES (@@IDENTITY, @creationDate, @filename)

END
GO
/****** Object:  StoredProcedure [dbo].[spCreateUser_]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- CRUD User_

-- CREATE
CREATE   PROCEDURE [dbo].[spCreateUser_](@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATETIME, @email VARCHAR(50), @idCampus INT) AS
BEGIN
    IF @userId IS NULL OR @userName IS NULL OR @birthDate IS NULL OR @email IS NULL OR @idCampus IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user already exists' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Campus WHERE campusId = @idCampus)
    BEGIN
        SELECT 'The campus does not exist' AS ExecMessage
        RETURN
    END

    INSERT INTO User_ (userId, userName, birthDate, email) VALUES (@userId, @userName, @birthDate, @email)
END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- DELETE
CREATE   PROCEDURE [dbo].[spDeleteFile](@fileId INT) AS
BEGIN
    IF @fileId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

    DELETE FROM File_ WHERE fileId = @fileId
END
GO
/****** Object:  StoredProcedure [dbo].[spDeleteUser_]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- DELETE 
CREATE   PROCEDURE [dbo].[spDeleteUser_](@userId VARCHAR(32)) AS
BEGIN
    BEGIN TRY
        IF @userId IS NULL
        BEGIN
            SELECT 'NULL parameters' AS ExecMessage
            RETURN
        END
        IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
        BEGIN
            SELECT 'The user does not exist' AS ExecMessage
            RETURN
        END

        DELETE FROM User_ WHERE userId = @userId
    END TRY
    BEGIN CATCH
        SELECT 'The user can not be deleted' AS ExecMessage
    END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spEnrollment]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP ENROLLMENT
CREATE   PROCEDURE [dbo].[spEnrollment](@userId VARCHAR(32), @schoolPeriodId INT, @courseGroupId INT, @enrollmentId INT) AS
BEGIN
    DECLARE @enrollmentSchedule INT, @previousSchoolPeriod INT, @meetsRequirements BIT, @courseId INT, @horarioInicio TIME, @horarioFinal TIME, @timeOfDay INT, @currentTime TIME, @dateOfToday DATETIME
    SET @previousSchoolPeriod = 0
    SET @enrollmentSchedule = 0
	SET @meetsRequirements = 0
    SET @dateOfToday = GETDATE()
	SET @timeOfDay = DATEPART(HOUR, @dateOfToday)
	SET @currentTime = (SELECT CONVERT(varchar, GETDATE(), 108))

    IF (SELECT EnrollmentStatus.description FROM EnrollmentStatus INNER JOIN Enrollment ON Enrollment.statusId = EnrollmentStatus.statusId WHERE @schoolPeriodId = periodId) = 'Inactivo'
        OR @dateOfToday < (SELECT Enrollment.startDate FROM Enrollment WHERE @schoolPeriodId = periodId) OR @dateOfToday > (SELECT Enrollment.endingDate FROM Enrollment WHERE @schoolPeriodId = periodId)
    BEGIN
        SELECT 'The date of enrollment period is not today or is closed' AS ExecMessage
        RETURN
    END
    IF @userId IS NULL OR @schoolPeriodId IS NULL OR @courseGroupId IS NULL OR @enrollmentId IS NULL OR @dateOfToday IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        SELECT 'The school period does not exist' AS ExecMessage
        RETURN
    END
    IF EXISTS(SELECT * FROM WeeklySchedule WHERE userId = @userId AND courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The user is already enrolled' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM CourseGroup WHERE courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The course group does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Enrollment WHERE enrollmentId = @enrollmentId)
    BEGIN
        SELECT 'The enrollment does not exist' AS ExecMessage
        RETURN
    END

	-- Validates if student meets all requirements to enroll the course
	SET @courseId =(SELECT courseId FROM CourseGroup WHERE courseGroupId = @courseGroupId)
	EXEC spMeetRequirements @userId, @courseId, @meetsRequirements OUTPUT

    IF @meetsRequirements = 0
    BEGIN
        SELECT 'Student does not meet the needed requirements to enroll this course' AS ExecMessage
        RETURN
    END 

	-- Validates if the schedule of the course group doesnt collide with another group schedule
	SET @horarioInicio = (SELECT startTime 
						  FROM ScheduleXDay 
						  INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.scheduleXDayId = ScheduleXDay.scheduleXDayId
                          INNER JOIN Schedule ON Schedule.scheduleId = ScheduleXDay.scheduleId
						  INNER JOIN CourseGroup ON CourseGroup.courseGroupId = ScheduleXCourseGroup.courseGroupId
						  WHERE CourseGroup.courseGroupId = @courseGroupId)
	SET @horarioFinal = (SELECT finishTime 
						  FROM ScheduleXDay
						  INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.scheduleXDayId = ScheduleXDay.scheduleXDayId
                          INNER JOIN Schedule ON Schedule.scheduleId = ScheduleXDay.scheduleId
						  INNER JOIN CourseGroup ON CourseGroup.courseGroupId = ScheduleXCourseGroup.courseGroupId
						  WHERE CourseGroup.courseGroupId = @courseGroupId)

	IF EXISTS (SELECT * FROM WeeklySchedule
				INNER JOIN CourseGroup ON WeeklySchedule.courseGroupId = CourseGroup.courseGroupId
				INNER JOIN ScheduleXCourseGroup ON ScheduleXCourseGroup.courseGroupId = CourseGroup.courseGroupId
                INNER JOIN ScheduleXDay ON ScheduleXDay.scheduleXDayId = ScheduleXCourseGroup.scheduleXDayId
				INNER JOIN Schedule ON Schedule.scheduleId = ScheduleXDay.scheduleId
				WHERE @schoolPeriodId = periodId AND
					  ( @horarioInicio BETWEEN startTime AND finishTime ) OR ( @horarioFinal BETWEEN startTime AND finishTime))
	BEGIN
		SELECT 'The schedule of the selected group collides with the schedule of other group' AS ExecMessage
        RETURN
	END

	-- Validates if student hasn't enrolled the same course in other group
	IF EXISTS (SELECT WeeklySchedule.courseGroupId 
				FROM Student
				INNER JOIN WeeklySchedule ON WeeklySchedule.userId = Student.userId
				INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
				INNER JOIN Course ON CourseGroup.courseId = Course.courseId
				WHERE Course.courseId = @courseId AND @userId = Student.userId)
	BEGIN
		SELECT 'The selected couse has already been enrolled in another group' AS ExecMessage
        RETURN
	END

    -- calculate the last school period of the student
    SET @previousSchoolPeriod = (SELECT TOP(1) schoolPeriodId FROM SchoolPeriod
        INNER JOIN CourseGroup ON SchoolPeriod.schoolPeriodId = CourseGroup.periodId
        INNER JOIN Course ON CourseGroup.courseId = Course.courseId
        INNER JOIN StudentXCourse ON Course.courseId = StudentXCourse.courseId
		INNER JOIN WeeklySchedule ON CourseGroup.courseGroupId = weeklySchedule.courseGroupId
        
        WHERE studentXCourse.userId = @userId 
		AND StudentXCourse.status = 1 ORDER BY schoolPeriodId DESC)

    IF @previousSchoolPeriod IS NULL
    BEGIN
        SET @enrollmentSchedule = 7
    END
    ELSE 
    BEGIN
        EXEC dbo.spEnrollmentTimeSchedule @userId, @previousSchoolPeriod, @enrollmentSchedule OUTPUT
    END

	-- Validates if the student can enroll in the current time (start time of enrollment to finish time of enrollment)
    IF (@timeOfDay < @enrollmentSchedule) OR (@timeOfDay > 15)
    BEGIN
        SELECT 'You can not enroll.' AS ExecMessage
        RETURN
    END

    INSERT INTO WeeklySchedule (userId, courseGroupId) VALUES (@userId, @courseGroupId)
    EXEC spInsertEnrollmentXStudent @enrollmentId, @schoolPeriodId, @userId, @currentTime
    SELECT 'User enrolled succesfully' AS ExecMessage
END
GO
/****** Object:  StoredProcedure [dbo].[spEnrollmentTimeSchedule]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP ENROLLMENT TIME SCHEDULE
CREATE   PROCEDURE [dbo].[spEnrollmentTimeSchedule](@userId VARCHAR(32), @schoolPeriodId INT, @enrollmentTimeScheduleValue INT OUTPUT) AS 
BEGIN
    IF @schoolPeriodId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        SELECT 'The school period does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    
    DECLARE @gradeAverageValue FLOAT
    EXEC spGetGradeAverage @userId, @schoolPeriodId, @gradeAverageValue OUTPUT
    SET @enrollmentTimeScheduleValue = 0

    IF @gradeAverageValue >= 95
    BEGIN
        SET @enrollmentTimeScheduleValue = 7
    END
    ELSE IF @gradeAverageValue >= 90
    BEGIN
        SET @enrollmentTimeScheduleValue = 8
    END
    ELSE IF @gradeAverageValue >= 85
    BEGIN
        SET @enrollmentTimeScheduleValue = 9
    END
    ELSE IF @gradeAverageValue >= 80
    BEGIN
        SET @enrollmentTimeScheduleValue = 10
    END
    ELSE IF @gradeAverageValue >= 75
    BEGIN
        SET @enrollmentTimeScheduleValue = 11
    END
    ELSE IF @gradeAverageValue >= 70
    BEGIN
        SET @enrollmentTimeScheduleValue = 12
    END

	SELECT @enrollmentTimeScheduleValue

END
GO
/****** Object:  StoredProcedure [dbo].[spGetAllVersionsOfFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP GET ALL VERSIONS OF FILE
CREATE   PROCEDURE [dbo].[spGetAllVersionsOfFile](@userId VARCHAR(32), @fileId INT) AS
BEGIN
    IF @userId IS NULL OR @fileId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

    SELECT Version.modificationDate FROM File_ INNER JOIN Version ON File_.fileId = Version.fileId WHERE userId = @userId AND File_.fileId = @fileId
END
GO
/****** Object:  StoredProcedure [dbo].[spGetCourses]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP GET CURSOS
CREATE   PROCEDURE [dbo].[spGetCourses](@userId VARCHAR(32)) AS
BEGIN
    IF @userId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END

    SELECT Course.courseId, courseName, credits, CourseEvaluation.description, CourseEvaluation.score
    FROM Course
    INNER JOIN StudentXCourse ON StudentXCourse.courseId = Course.courseId
    INNER JOIN Student ON Student.userId = StudentXCourse.userId
    INNER JOIN CareerXUser ON CareerXUser.userId = Student.userId
    INNER JOIN CareerPlan ON CareerPlan.careerId = CareerXUser.careerId
    INNER JOIN CourseXPlan ON CourseXPlan.planId = CareerPlan.planId
	INNER JOIN CourseGroup ON CourseGroup.courseId = Course.courseId
    INNER JOIN CourseEvaluation ON CourseEvaluation.courseGroupId = CourseGroup.courseGroupId
    WHERE Student.userId = @userId AND StudentXCourse.status = 1

END
GO
/****** Object:  StoredProcedure [dbo].[spGetGradeAverage]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP GET GRADE AVERAGE
CREATE   PROCEDURE [dbo].[spGetGradeAverage](@userId VARCHAR(32), @schoolPeriodId INT, @resultado INT OUTPUT) AS
BEGIN
    DECLARE @sum FLOAT, @courseAmount INT
    SET @sum = 0
	SET @courseAmount = 0

    IF @userId IS NULL OR @schoolPeriodId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        SELECT 0
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        SELECT 0
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        IF @schoolPeriodId <= 0
        BEGIN
            SELECT 'It is the first school period' AS ExecMessage
            SELECT 100
        END

        SELECT 'The school period does not exist' AS ExecMessage
        SELECT 0
    END

	SET @courseAmount = (SELECT COUNT(CourseGroup.courseGroupId) AS total 
                    FROM Student
                    INNER JOIN WeeklySchedule ON Student.userId = WeeklySchedule.userId
                    INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
                    INNER JOIN SchoolPeriod ON SchoolPeriod.schoolPeriodId = CourseGroup.periodId
                    WHERE Student.userId = @userId AND SchoolPeriod.schoolPeriodId = @schoolPeriodId)

    SET @sum = (SELECT SUM(grade) AS totalSum 
                    FROM Student
                    INNER JOIN WeeklySchedule ON Student.userId = WeeklySchedule.userId
                    INNER JOIN CourseGroup ON CourseGroup.courseGroupId = WeeklySchedule.courseGroupId
                    INNER JOIN SchoolPeriod ON SchoolPeriod.schoolPeriodId = CourseGroup.periodId
                    INNER JOIN Evaluation ON Evaluation.courseGroupId = CourseGroup.courseGroupId
                    INNER JOIN Item ON Item.evaluationId = Evaluation.evaluationId
                    INNER JOIN StudentXItem ON StudentXItem.itemId = Item.itemId AND StudentXItem.userId = Student.userId

                    WHERE Student.userId = @userId AND SchoolPeriod.schoolPeriodId = @schoolPeriodId) 

    SET @resultado = @sum / @courseAmount
	SELECT @sum / @courseAmount
	
END
GO
/****** Object:  StoredProcedure [dbo].[spGetLatestFileVersion]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- SP GET LATESTS FILE VERSION
CREATE   PROCEDURE [dbo].[spGetLatestFileVersion](@userId VARCHAR(32), @fileId INT) AS
BEGIN
    IF @userId IS NULL OR @fileId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

    SELECT TOP 1 File_.fileId  FROM File_ INNER JOIN Version ON File_.fileId = Version.fileId WHERE userId = @userId AND File_.fileId = @fileId ORDER BY modificationDate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[spGetVersionOfFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- GET VERSION OF FILE
CREATE   PROCEDURE [dbo].[spGetVersionOfFile](@userId VARCHAR(32), @fileId INT, @modificationDate DATE) AS
BEGIN
    IF @userId IS NULL OR @fileId IS NULL OR @modificationDate IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Version WHERE fileId = @fileId AND modificationDate = @modificationDate)
    BEGIN
        SELECT 'The version does not exist' AS ExecMessage
        RETURN
    END

    SELECT filename FROM Version WHERE fileId = @fileId AND modificationDate = @modificationDate
END
GO
/****** Object:  StoredProcedure [dbo].[spInsertEnrollmentXStudent]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP INSERT ENROLLMENTXSTUDENT
CREATE   PROCEDURE [dbo].[spInsertEnrollmentXStudent](@enrollmentId INT, @schoolPeriodId INT, @userId VARCHAR(32), @enrollmentTime TIME) AS
BEGIN
	DECLARE @time INT
	SET @time = DATEPART(HOUR, @enrollmentTime)
    IF @enrollmentId IS NULL OR @userId IS NULL OR @time IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Enrollment WHERE enrollmentId = @enrollmentId)
    BEGIN
        SELECT 'The enrollment does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF @time <= 0
    BEGIN
        SELECT 'The time must be greater than 0' AS ExecMessage
        RETURN
    END

    INSERT INTO EnrollmentXStudent(enrollmentTime, userId, enrollmentId) VALUES(@enrollmentTime, @userId, @enrollmentId)
END
GO
/****** Object:  StoredProcedure [dbo].[spMeetRequirements]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- SP STUDENT MEETS ALL REQUIREMENTS TO ENROLL THE COURSE
CREATE   PROCEDURE [dbo].[spMeetRequirements](@userId VARCHAR(32), @courseId INT, @meetsRequirements BIT OUTPUT) AS
BEGIN

IF @userId IS NULL OR @courseId IS NULL
BEGIN
    SELECT 'NULL parameters' AS ExecMessage
    RETURN
END
IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
BEGIN
    SELECT 'The user does not exist' AS ExecMessage
    RETURN
END
IF NOT EXISTS(SELECT * FROM Course WHERE courseId = @courseId)
BEGIN
    SELECT 'The course does not exist' AS ExecMessage
    RETURN
END

CREATE TABLE #TCourseRequirement (
   courseRequirementId INT,
   courseId INT,
   courseXPlanId INT
)


INSERT INTO #TCourseRequirement (courseRequirementId, courseId, courseXPlanId)
SELECT courseRequirementId, courseId, courseXPlanId
FROM CourseRequirement
WHERE courseXPlanId = (SELECT courseXPlanId FROM CourseXPlan WHERE courseId = @courseId)

-- SELECT * FROM #TCourseRequirement

WHILE (SELECT COUNT(*) FROM #TCourseRequirement) != 0
BEGIN

IF (SELECT TOP(1) StudentXCourse.status FROM StudentXCourse INNER JOIN CourseXPlan ON CourseXPlan.courseId = StudentXCourse.courseId INNER JOIN CourseRequirement ON CourseXPlan.courseXPlanId = CourseRequirement.courseXPlanId INNER JOIN Course ON Course.courseId = CourseXPlan.courseId WHERE Course.courseId = @courseId) = 0
BEGIN
	SET @meetsRequirements = 0
	--SELECT @meetsRequirements
	RETURN
END

DELETE TOP(1) FROM #TCourseRequirement


END

DROP TABLE #TCourseRequirement

SET @meetsRequirements = 1
--SELECT @meetsRequirements

END
GO
/****** Object:  StoredProcedure [dbo].[spModifyFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP MODIFY FILE (NEW VERSION)
CREATE   PROCEDURE [dbo].[spModifyFile](@userId VARCHAR(32), @fileId INT, @modificationDate DATE, @name VARCHAR(50), @description VARCHAR(100), @error INT OUTPUT) AS
BEGIN
    IF @userId IS NULL OR @fileId IS NULL OR @modificationDate IS NULL OR @name IS NULL OR @description IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId AND userId = @userId)
    BEGIN
        SELECT 'The user does not own the file' AS ExecMessage
        SET @error = 1
        RETURN
    END

    DECLARE @updateError INT 
    SET @updateError = 0

    EXEC spUpdateFile @fileId, NULL, NULL, NULL, @name, @description, @updateError OUTPUT

    IF @updateError = 1
    BEGIN
        SELECT 'The file could not be updated' AS ExecMessage
        SET @error = 1
        RETURN
    END

    INSERT INTO Version (fileId, modificationDate, filename) VALUES (@fileId, @modificationDate, @name)
    SET @error = 0

END
GO
/****** Object:  StoredProcedure [dbo].[spReadFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- READ
CREATE   PROCEDURE [dbo].[spReadFile](@fileId INT) AS
BEGIN
    IF @fileId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        RETURN
    END

    SELECT * FROM File_ WHERE fileId = @fileId
END
GO
/****** Object:  StoredProcedure [dbo].[spReadSchoolPeriod]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP READ SCHOOL PERIOD
CREATE   PROCEDURE [dbo].[spReadSchoolPeriod](@schoolPeriodId INT) AS
BEGIN
    IF @schoolPeriodId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId)
    BEGIN
        SELECT 'The school period does not exist' AS ExecMessage
        RETURN
    END
    SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @schoolPeriodId
END
GO
/****** Object:  StoredProcedure [dbo].[spReadUser_]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- READ
CREATE   PROCEDURE [dbo].[spReadUser_](@userId VARCHAR(32)) AS
BEGIN
    IF @userId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END

    SELECT * FROM User_ WHERE userId = @userId
END
GO
/****** Object:  StoredProcedure [dbo].[spUnregister]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SP UNREGISTER
CREATE   PROCEDURE [dbo].[spUnregister](@userId VARCHAR(32), @courseGroupId INT) AS
BEGIN
    IF @userId IS NULL OR @courseGroupId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM CourseGroup WHERE courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The course group does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM WeeklySchedule WHERE userId = @userId AND courseGroupId = @courseGroupId)
    BEGIN
        SELECT 'The user is not enrolled' AS ExecMessage
        RETURN
    END

    DELETE FROM WeeklySchedule WHERE userId = @userId AND courseGroupId = @courseGroupId
    SELECT 'User unregistered succesfully' AS ExecMessage
END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateFile]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- UPDATE
CREATE   PROCEDURE [dbo].[spUpdateFile](@fileId INT, @fileTypeId INT, @periodId INT, @creationDate DATE, @name VARCHAR(50), @description VARCHAR(100), @error INT OUTPUT) AS
BEGIN
    IF @fileId IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM File_ WHERE fileId = @fileId)
    BEGIN
        SELECT 'The file does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF @fileTypeId IS NOT NULL AND NOT EXISTS(SELECT * FROM FileType WHERE fileTypeId = @fileTypeId)
    BEGIN
        SELECT 'The file type does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END
    IF @periodId IS NOT NULL AND NOT EXISTS(SELECT * FROM SchoolPeriod WHERE schoolPeriodId = @periodId)
    BEGIN
        SELECT 'The period does not exist' AS ExecMessage
        SET @error = 1
        RETURN
    END

    UPDATE File_ SET fileTypeId = ISNULL(@fileTypeId, fileTypeId), periodId = ISNULL(@periodId, periodId), creationDate = ISNULL(@creationDate, creationDate), name = ISNULL(@name, name), description = ISNULL(@description, description) WHERE fileId = @fileId
    SET @error = 0
END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUser_]    Script Date: 4/25/2023 12:13:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- UPDATE
CREATE   PROCEDURE [dbo].[spUpdateUser_](@userId VARCHAR(32), @userName VARCHAR(50), @birthDate DATETIME, @email VARCHAR(50), @idCampus INT) AS
BEGIN
    IF @userId IS NULL OR @userName IS NULL OR @birthDate IS NULL OR @email IS NULL OR @idCampus IS NULL
    BEGIN
        SELECT 'NULL parameters' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM User_ WHERE userId = @userId)
    BEGIN
        SELECT 'The user does not exist' AS ExecMessage
        RETURN
    END
    IF NOT EXISTS(SELECT * FROM Campus WHERE campusId = @idCampus)
    BEGIN
        SELECT 'The campus does not exist' AS ExecMessage
        RETURN
    END

    UPDATE User_ SET userName = ISNULL(@userName, userName), birthDate = ISNULL(@birthDate, birthDate), email = ISNULL(@email, email) WHERE userId = @userId
END
GO
USE [master]
GO
ALTER DATABASE [db01] SET  READ_WRITE 
GO
