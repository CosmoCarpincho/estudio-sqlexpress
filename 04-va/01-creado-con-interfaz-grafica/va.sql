USE [master]
GO
/****** Object:  Database [va02]    Script Date: 31/5/2025 14:32:40 ******/
CREATE DATABASE [va02]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'va02', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\va02.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'va02_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\va02_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [va02] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [va02].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [va02] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [va02] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [va02] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [va02] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [va02] SET ARITHABORT OFF 
GO
ALTER DATABASE [va02] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [va02] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [va02] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [va02] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [va02] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [va02] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [va02] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [va02] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [va02] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [va02] SET  DISABLE_BROKER 
GO
ALTER DATABASE [va02] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [va02] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [va02] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [va02] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [va02] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [va02] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [va02] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [va02] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [va02] SET  MULTI_USER 
GO
ALTER DATABASE [va02] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [va02] SET DB_CHAINING OFF 
GO
ALTER DATABASE [va02] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [va02] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [va02] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [va02] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [va02] SET QUERY_STORE = ON
GO
ALTER DATABASE [va02] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [va02]
GO
/****** Object:  Table [dbo].[Deposito]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Deposito](
	[IdDeposito] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
 CONSTRAINT [PK_Deposito] PRIMARY KEY CLUSTERED 
(
	[IdDeposito] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadoOC]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoOC](
	[IdEstadoOC] [int] NOT NULL,
	[Nombre] [nvarchar](50) NULL,
 CONSTRAINT [PK_EstadoOC] PRIMARY KEY CLUSTERED 
(
	[IdEstadoOC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadoOE]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoOE](
	[IdEstadoOE] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EstadoOE] PRIMARY KEY CLUSTERED 
(
	[IdEstadoOE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadoOF]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoOF](
	[IdEstadoOF] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EstadoOF] PRIMARY KEY CLUSTERED 
(
	[IdEstadoOF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EstadoOR]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoOR](
	[IdEstadoOR] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_EstadoOR] PRIMARY KEY CLUSTERED 
(
	[IdEstadoOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Formula]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Formula](
	[IdFormula] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
 CONSTRAINT [PK_Formula] PRIMARY KEY CLUSTERED 
(
	[IdFormula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Linea]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Linea](
	[IdLinea] [int] NOT NULL,
	[IdSector] [int] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
 CONSTRAINT [PK_Linea] PRIMARY KEY CLUSTERED 
(
	[IdLinea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoCompra]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoCompra](
	[IdMovimiento] [int] NOT NULL,
	[NroCompra] [int] NOT NULL,
	[PrecioUnitario] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_MovimientoCompra] PRIMARY KEY CLUSTERED 
(
	[IdMovimiento] ASC,
	[NroCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoEntrega]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoEntrega](
	[NroEntrega] [int] NOT NULL,
	[IdMovimiento] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoEntrega] PRIMARY KEY CLUSTERED 
(
	[NroEntrega] ASC,
	[IdMovimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoFabricacion]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoFabricacion](
	[NroFabricacion] [int] NOT NULL,
	[IdMovimiento] [int] NOT NULL,
	[Destino] [nvarchar](50) NOT NULL,
	[Calidad] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MovimientoFabricacion] PRIMARY KEY CLUSTERED 
(
	[NroFabricacion] ASC,
	[IdMovimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoPallet]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoPallet](
	[IdMovimiento] [int] NOT NULL,
	[IdPallet] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoPallet] PRIMARY KEY CLUSTERED 
(
	[IdMovimiento] ASC,
	[IdPallet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoStock]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoStock](
	[IdMovimiento] [int] NOT NULL,
	[CodProducto] [int] NOT NULL,
	[FechaVencimiento] [datetime] NOT NULL,
	[IdDepostio] [int] NOT NULL,
	[FechaMovimiento] [datetime] NOT NULL,
	[CantidadModificada] [int] NOT NULL,
	[IdUM] [int] NOT NULL,
	[Lote] [nvarchar](100) NOT NULL,
	[TipoMovimiento] [nchar](10) NOT NULL,
 CONSTRAINT [PK_MovimientoStock] PRIMARY KEY CLUSTERED 
(
	[IdMovimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenCompra]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenCompra](
	[NroCompra] [int] NOT NULL,
	[IdProveedor] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaCompra] [datetime] NOT NULL,
	[IdEstadoOC] [int] NOT NULL,
 CONSTRAINT [PK_OrdenCompra] PRIMARY KEY CLUSTERED 
(
	[NroCompra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenEntrega]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenEntrega](
	[NroEntrega] [int] NOT NULL,
	[SectorSolicita] [int] NOT NULL,
	[SectorProvee] [int] NOT NULL,
	[FechaAlta] [datetime] NOT NULL,
	[IdEstadoOE] [int] NOT NULL,
	[DepositoSolicita] [int] NOT NULL,
	[DepositoProvee] [int] NOT NULL,
	[UsuarioAlta] [int] NOT NULL,
	[UsuarioRecepcion] [int] NULL,
	[FechaRecepcion] [datetime] NULL,
	[EsAnulado] [bit] NOT NULL,
 CONSTRAINT [PK_OrdenEntrega] PRIMARY KEY CLUSTERED 
(
	[NroEntrega] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenFabricacion]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenFabricacion](
	[NroFabricacion] [int] NOT NULL,
	[IdFormula] [int] NOT NULL,
	[IdLinea] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[IdEstadoOF] [int] NOT NULL,
	[FechaPlanificacion] [datetime] NOT NULL,
	[FechaInicio] [datetime] NOT NULL,
	[FechaFin] [datetime] NULL,
	[EsAnulado] [bit] NOT NULL,
 CONSTRAINT [PK_OrdenFabricacion] PRIMARY KEY CLUSTERED 
(
	[NroFabricacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenReposicion]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenReposicion](
	[NroReposicion] [int] NOT NULL,
	[SectorSolicita] [int] NOT NULL,
	[SectorProvee] [int] NOT NULL,
	[IdEstadoOR] [int] NOT NULL,
	[EsAnulado] [bit] NOT NULL,
 CONSTRAINT [PK_OrdenReposicion] PRIMARY KEY CLUSTERED 
(
	[NroReposicion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrdenReposicionDetalle]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdenReposicionDetalle](
	[NroReposicion] [int] NOT NULL,
	[CodProducto] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
 CONSTRAINT [PK_OrdenReposicionDetalle] PRIMARY KEY CLUSTERED 
(
	[NroReposicion] ASC,
	[CodProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pallet]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pallet](
	[IdPallet] [int] NOT NULL,
	[IdTipoPallet] [int] NOT NULL,
	[IdDeposito] [int] NOT NULL,
	[CantidadDisponible] [int] NULL,
 CONSTRAINT [PK_Pallet] PRIMARY KEY CLUSTERED 
(
	[IdPallet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permiso]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permiso](
	[IdPermiso] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
 CONSTRAINT [PK_Permiso] PRIMARY KEY CLUSTERED 
(
	[IdPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[CodProducto] [int] NOT NULL,
	[IdFormula] [int] NULL,
	[Descripcion] [nvarchar](255) NULL,
 CONSTRAINT [PK_Producto] PRIMARY KEY CLUSTERED 
(
	[CodProducto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedor]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedor](
	[IdProveedor] [int] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Calle] [nvarchar](150) NULL,
	[Nro] [nvarchar](150) NULL,
	[Localidad] [nvarchar](150) NULL,
 CONSTRAINT [PK_Proveedor] PRIMARY KEY CLUSTERED 
(
	[IdProveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rol]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rol](
	[IdRol] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nchar](255) NULL,
 CONSTRAINT [PK_Rol] PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolPermiso]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolPermiso](
	[IdRol] [int] NOT NULL,
	[IdPermiso] [int] NOT NULL,
 CONSTRAINT [PK_RolPermiso] PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC,
	[IdPermiso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sector]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sector](
	[IdSector] [int] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
 CONSTRAINT [PK_Sector] PRIMARY KEY CLUSTERED 
(
	[IdSector] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Telefono]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Telefono](
	[IdTelefono] [int] NOT NULL,
	[IdProveedor] [int] NOT NULL,
	[Numero] [int] NOT NULL,
	[TipoTelefono] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Telefono] PRIMARY KEY CLUSTERED 
(
	[IdTelefono] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoPallet]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoPallet](
	[IdTipoPallet] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[IdUM] [int] NOT NULL,
	[Capcidad] [int] NOT NULL,
 CONSTRAINT [PK_TipoPallet] PRIMARY KEY CLUSTERED 
(
	[IdTipoPallet] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UnidadMedida]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UnidadMedida](
	[IdUM] [int] NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
 CONSTRAINT [PK_UnidadMedida] PRIMARY KEY CLUSTERED 
(
	[IdUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[IdUsuario] [int] NOT NULL,
	[Clave] [nvarchar](255) NOT NULL,
	[FechaAlta] [datetime] NOT NULL,
	[Nombre] [nvarchar](50) NULL,
	[Apellido] [nvarchar](50) NULL,
	[Email] [nvarchar](230) NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuarioFormula]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuarioFormula](
	[IdUsuario] [int] NOT NULL,
	[IdFormula] [int] NOT NULL,
 CONSTRAINT [PK_UsuarioFormula] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[IdFormula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsuarioRol]    Script Date: 31/5/2025 14:32:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsuarioRol](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaAltaRol] [datetime] NULL,
 CONSTRAINT [PK_UsuarioRol] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Linea]  WITH CHECK ADD  CONSTRAINT [FK_Linea_Sector] FOREIGN KEY([IdSector])
REFERENCES [dbo].[Sector] ([IdSector])
GO
ALTER TABLE [dbo].[Linea] CHECK CONSTRAINT [FK_Linea_Sector]
GO
ALTER TABLE [dbo].[MovimientoCompra]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCompra_MovimientoStock] FOREIGN KEY([IdMovimiento])
REFERENCES [dbo].[MovimientoStock] ([IdMovimiento])
GO
ALTER TABLE [dbo].[MovimientoCompra] CHECK CONSTRAINT [FK_MovimientoCompra_MovimientoStock]
GO
ALTER TABLE [dbo].[MovimientoCompra]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoCompra_OrdenCompra] FOREIGN KEY([NroCompra])
REFERENCES [dbo].[OrdenCompra] ([NroCompra])
GO
ALTER TABLE [dbo].[MovimientoCompra] CHECK CONSTRAINT [FK_MovimientoCompra_OrdenCompra]
GO
ALTER TABLE [dbo].[MovimientoEntrega]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoEntrega_MovimientoStock] FOREIGN KEY([IdMovimiento])
REFERENCES [dbo].[MovimientoStock] ([IdMovimiento])
GO
ALTER TABLE [dbo].[MovimientoEntrega] CHECK CONSTRAINT [FK_MovimientoEntrega_MovimientoStock]
GO
ALTER TABLE [dbo].[MovimientoEntrega]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoEntrega_OrdenEntrega] FOREIGN KEY([NroEntrega])
REFERENCES [dbo].[OrdenEntrega] ([NroEntrega])
GO
ALTER TABLE [dbo].[MovimientoEntrega] CHECK CONSTRAINT [FK_MovimientoEntrega_OrdenEntrega]
GO
ALTER TABLE [dbo].[MovimientoFabricacion]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoFabricacion_MovimientoStock] FOREIGN KEY([IdMovimiento])
REFERENCES [dbo].[MovimientoStock] ([IdMovimiento])
GO
ALTER TABLE [dbo].[MovimientoFabricacion] CHECK CONSTRAINT [FK_MovimientoFabricacion_MovimientoStock]
GO
ALTER TABLE [dbo].[MovimientoFabricacion]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoFabricacion_OrdenFabricacion] FOREIGN KEY([NroFabricacion])
REFERENCES [dbo].[OrdenFabricacion] ([NroFabricacion])
GO
ALTER TABLE [dbo].[MovimientoFabricacion] CHECK CONSTRAINT [FK_MovimientoFabricacion_OrdenFabricacion]
GO
ALTER TABLE [dbo].[MovimientoPallet]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoPallet_MovimientoStock] FOREIGN KEY([IdMovimiento])
REFERENCES [dbo].[MovimientoStock] ([IdMovimiento])
GO
ALTER TABLE [dbo].[MovimientoPallet] CHECK CONSTRAINT [FK_MovimientoPallet_MovimientoStock]
GO
ALTER TABLE [dbo].[MovimientoPallet]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoPallet_Pallet] FOREIGN KEY([IdPallet])
REFERENCES [dbo].[Pallet] ([IdPallet])
GO
ALTER TABLE [dbo].[MovimientoPallet] CHECK CONSTRAINT [FK_MovimientoPallet_Pallet]
GO
ALTER TABLE [dbo].[MovimientoStock]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoStock_Deposito] FOREIGN KEY([IdDepostio])
REFERENCES [dbo].[Deposito] ([IdDeposito])
GO
ALTER TABLE [dbo].[MovimientoStock] CHECK CONSTRAINT [FK_MovimientoStock_Deposito]
GO
ALTER TABLE [dbo].[MovimientoStock]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoStock_Producto] FOREIGN KEY([CodProducto])
REFERENCES [dbo].[Producto] ([CodProducto])
GO
ALTER TABLE [dbo].[MovimientoStock] CHECK CONSTRAINT [FK_MovimientoStock_Producto]
GO
ALTER TABLE [dbo].[MovimientoStock]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoStock_UnidadMedida] FOREIGN KEY([IdUM])
REFERENCES [dbo].[UnidadMedida] ([IdUM])
GO
ALTER TABLE [dbo].[MovimientoStock] CHECK CONSTRAINT [FK_MovimientoStock_UnidadMedida]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenCompra_EstadoOC] FOREIGN KEY([IdEstadoOC])
REFERENCES [dbo].[EstadoOC] ([IdEstadoOC])
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [FK_OrdenCompra_EstadoOC]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenCompra_Proveedor] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[Proveedor] ([IdProveedor])
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [FK_OrdenCompra_Proveedor]
GO
ALTER TABLE [dbo].[OrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_OrdenCompra_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([IdUsuario])
GO
ALTER TABLE [dbo].[OrdenCompra] CHECK CONSTRAINT [FK_OrdenCompra_Usuario]
GO
ALTER TABLE [dbo].[OrdenEntrega]  WITH CHECK ADD  CONSTRAINT [FK_OrdenEntrega_Deposito_Provee] FOREIGN KEY([DepositoProvee])
REFERENCES [dbo].[Deposito] ([IdDeposito])
GO
ALTER TABLE [dbo].[OrdenEntrega] CHECK CONSTRAINT [FK_OrdenEntrega_Deposito_Provee]
GO
ALTER TABLE [dbo].[OrdenEntrega]  WITH CHECK ADD  CONSTRAINT [FK_OrdenEntrega_Deposito_Solicita] FOREIGN KEY([DepositoSolicita])
REFERENCES [dbo].[Deposito] ([IdDeposito])
GO
ALTER TABLE [dbo].[OrdenEntrega] CHECK CONSTRAINT [FK_OrdenEntrega_Deposito_Solicita]
GO
ALTER TABLE [dbo].[OrdenEntrega]  WITH CHECK ADD  CONSTRAINT [FK_OrdenEntrega_EstadoOE] FOREIGN KEY([IdEstadoOE])
REFERENCES [dbo].[EstadoOE] ([IdEstadoOE])
GO
ALTER TABLE [dbo].[OrdenEntrega] CHECK CONSTRAINT [FK_OrdenEntrega_EstadoOE]
GO
ALTER TABLE [dbo].[OrdenEntrega]  WITH CHECK ADD  CONSTRAINT [FK_OrdenEntrega_Sector_Provee] FOREIGN KEY([SectorProvee])
REFERENCES [dbo].[Sector] ([IdSector])
GO
ALTER TABLE [dbo].[OrdenEntrega] CHECK CONSTRAINT [FK_OrdenEntrega_Sector_Provee]
GO
ALTER TABLE [dbo].[OrdenEntrega]  WITH CHECK ADD  CONSTRAINT [FK_OrdenEntrega_Sector_Solicita] FOREIGN KEY([SectorSolicita])
REFERENCES [dbo].[Sector] ([IdSector])
GO
ALTER TABLE [dbo].[OrdenEntrega] CHECK CONSTRAINT [FK_OrdenEntrega_Sector_Solicita]
GO
ALTER TABLE [dbo].[OrdenEntrega]  WITH CHECK ADD  CONSTRAINT [FK_OrdenEntrega_Usuario_Alta] FOREIGN KEY([UsuarioAlta])
REFERENCES [dbo].[Usuario] ([IdUsuario])
GO
ALTER TABLE [dbo].[OrdenEntrega] CHECK CONSTRAINT [FK_OrdenEntrega_Usuario_Alta]
GO
ALTER TABLE [dbo].[OrdenEntrega]  WITH CHECK ADD  CONSTRAINT [FK_OrdenEntrega_Usuario_Recepcion] FOREIGN KEY([UsuarioRecepcion])
REFERENCES [dbo].[Usuario] ([IdUsuario])
GO
ALTER TABLE [dbo].[OrdenEntrega] CHECK CONSTRAINT [FK_OrdenEntrega_Usuario_Recepcion]
GO
ALTER TABLE [dbo].[OrdenFabricacion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenFabricacion_Formula] FOREIGN KEY([IdFormula])
REFERENCES [dbo].[Formula] ([IdFormula])
GO
ALTER TABLE [dbo].[OrdenFabricacion] CHECK CONSTRAINT [FK_OrdenFabricacion_Formula]
GO
ALTER TABLE [dbo].[OrdenFabricacion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenFabricacion_Linea] FOREIGN KEY([IdLinea])
REFERENCES [dbo].[Linea] ([IdLinea])
GO
ALTER TABLE [dbo].[OrdenFabricacion] CHECK CONSTRAINT [FK_OrdenFabricacion_Linea]
GO
ALTER TABLE [dbo].[OrdenFabricacion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenFabricacion_OrdenFabricacion] FOREIGN KEY([IdEstadoOF])
REFERENCES [dbo].[EstadoOF] ([IdEstadoOF])
GO
ALTER TABLE [dbo].[OrdenFabricacion] CHECK CONSTRAINT [FK_OrdenFabricacion_OrdenFabricacion]
GO
ALTER TABLE [dbo].[OrdenFabricacion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenFabricacion_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([IdUsuario])
GO
ALTER TABLE [dbo].[OrdenFabricacion] CHECK CONSTRAINT [FK_OrdenFabricacion_Usuario]
GO
ALTER TABLE [dbo].[OrdenReposicion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenReposicion_EstadoOR] FOREIGN KEY([IdEstadoOR])
REFERENCES [dbo].[EstadoOR] ([IdEstadoOR])
GO
ALTER TABLE [dbo].[OrdenReposicion] CHECK CONSTRAINT [FK_OrdenReposicion_EstadoOR]
GO
ALTER TABLE [dbo].[OrdenReposicion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenReposicion_Sector_Provee] FOREIGN KEY([SectorProvee])
REFERENCES [dbo].[Sector] ([IdSector])
GO
ALTER TABLE [dbo].[OrdenReposicion] CHECK CONSTRAINT [FK_OrdenReposicion_Sector_Provee]
GO
ALTER TABLE [dbo].[OrdenReposicion]  WITH CHECK ADD  CONSTRAINT [FK_OrdenReposicion_Sector_Solicita] FOREIGN KEY([SectorSolicita])
REFERENCES [dbo].[Sector] ([IdSector])
GO
ALTER TABLE [dbo].[OrdenReposicion] CHECK CONSTRAINT [FK_OrdenReposicion_Sector_Solicita]
GO
ALTER TABLE [dbo].[OrdenReposicionDetalle]  WITH CHECK ADD  CONSTRAINT [FK_OrdenReposicionDetalle_OrdenReposicion] FOREIGN KEY([NroReposicion])
REFERENCES [dbo].[OrdenReposicion] ([NroReposicion])
GO
ALTER TABLE [dbo].[OrdenReposicionDetalle] CHECK CONSTRAINT [FK_OrdenReposicionDetalle_OrdenReposicion]
GO
ALTER TABLE [dbo].[OrdenReposicionDetalle]  WITH CHECK ADD  CONSTRAINT [FK_OrdenReposicionDetalle_Producto] FOREIGN KEY([CodProducto])
REFERENCES [dbo].[Producto] ([CodProducto])
GO
ALTER TABLE [dbo].[OrdenReposicionDetalle] CHECK CONSTRAINT [FK_OrdenReposicionDetalle_Producto]
GO
ALTER TABLE [dbo].[Pallet]  WITH CHECK ADD  CONSTRAINT [FK_Pallet_TipoPallet] FOREIGN KEY([IdTipoPallet])
REFERENCES [dbo].[TipoPallet] ([IdTipoPallet])
GO
ALTER TABLE [dbo].[Pallet] CHECK CONSTRAINT [FK_Pallet_TipoPallet]
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD  CONSTRAINT [FK_Producto_Formula] FOREIGN KEY([IdFormula])
REFERENCES [dbo].[Formula] ([IdFormula])
GO
ALTER TABLE [dbo].[Producto] CHECK CONSTRAINT [FK_Producto_Formula]
GO
ALTER TABLE [dbo].[RolPermiso]  WITH CHECK ADD  CONSTRAINT [FK_RolPermiso_Permiso] FOREIGN KEY([IdPermiso])
REFERENCES [dbo].[Permiso] ([IdPermiso])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RolPermiso] CHECK CONSTRAINT [FK_RolPermiso_Permiso]
GO
ALTER TABLE [dbo].[RolPermiso]  WITH CHECK ADD  CONSTRAINT [FK_RolPermiso_Rol] FOREIGN KEY([IdRol])
REFERENCES [dbo].[Rol] ([IdRol])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RolPermiso] CHECK CONSTRAINT [FK_RolPermiso_Rol]
GO
ALTER TABLE [dbo].[Telefono]  WITH CHECK ADD  CONSTRAINT [FK_Telefono_Proveedor] FOREIGN KEY([IdProveedor])
REFERENCES [dbo].[Proveedor] ([IdProveedor])
GO
ALTER TABLE [dbo].[Telefono] CHECK CONSTRAINT [FK_Telefono_Proveedor]
GO
ALTER TABLE [dbo].[TipoPallet]  WITH CHECK ADD  CONSTRAINT [FK_TipoPallet_UnidadMedida] FOREIGN KEY([IdUM])
REFERENCES [dbo].[UnidadMedida] ([IdUM])
GO
ALTER TABLE [dbo].[TipoPallet] CHECK CONSTRAINT [FK_TipoPallet_UnidadMedida]
GO
ALTER TABLE [dbo].[UsuarioFormula]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioFormula_Formula] FOREIGN KEY([IdFormula])
REFERENCES [dbo].[Formula] ([IdFormula])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsuarioFormula] CHECK CONSTRAINT [FK_UsuarioFormula_Formula]
GO
ALTER TABLE [dbo].[UsuarioFormula]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioFormula_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([IdUsuario])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsuarioFormula] CHECK CONSTRAINT [FK_UsuarioFormula_Usuario]
GO
ALTER TABLE [dbo].[UsuarioRol]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioRol_Rol] FOREIGN KEY([IdRol])
REFERENCES [dbo].[Rol] ([IdRol])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsuarioRol] CHECK CONSTRAINT [FK_UsuarioRol_Rol]
GO
ALTER TABLE [dbo].[UsuarioRol]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioRol_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([IdUsuario])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UsuarioRol] CHECK CONSTRAINT [FK_UsuarioRol_Usuario]
GO
ALTER TABLE [dbo].[EstadoOR]  WITH CHECK ADD  CONSTRAINT [CK_EstadoOR_Nombre] CHECK  (([Nombre]='Cerrado' OR [Nombre]='Solicitado' OR [Nombre]='Proceso'))
GO
ALTER TABLE [dbo].[EstadoOR] CHECK CONSTRAINT [CK_EstadoOR_Nombre]
GO
ALTER TABLE [dbo].[MovimientoFabricacion]  WITH CHECK ADD  CONSTRAINT [CK_MovimientoFabricacion_Calidad] CHECK  (([Calidad]='Transferencia Directa' OR [Calidad]='Requiere'))
GO
ALTER TABLE [dbo].[MovimientoFabricacion] CHECK CONSTRAINT [CK_MovimientoFabricacion_Calidad]
GO
ALTER TABLE [dbo].[MovimientoFabricacion]  WITH CHECK ADD  CONSTRAINT [CK_MovimientoFabricacion_Destino] CHECK  (([Destino]='Muestra' OR [Destino]='Venta'))
GO
ALTER TABLE [dbo].[MovimientoFabricacion] CHECK CONSTRAINT [CK_MovimientoFabricacion_Destino]
GO
USE [master]
GO
ALTER DATABASE [va02] SET  READ_WRITE 
GO
