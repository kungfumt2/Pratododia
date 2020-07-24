CREATE DATABASE bdpratodia

USE bdpratodia
GO

CREATE TABLE Utilizador(
Id INTEGER NOT NULL IDENTITY(1,1),
Username VARCHAR(MAX) NOT NULL,
Nome VARCHAR(MAX) NOT NULL,
PW VARCHAR(MAX) NOT NULL,
Email VARCHAR(MAX) NOT NULL,
Estado VARCHAR(MAX) NOT NULL,
DataAsesao DATETIME2 NOT NULL,
PRIMARY KEY(Id))

DELETE FROM FotografiasR

CREATE TABLE Cliente(
IdUser INTEGER NOT NULL,
PRIMARY KEY(IdUser),
FOREIGN KEY(IdUser) REFERENCES Utilizador(Id))

CREATE TABLE Proprietario(
IdUser INTEGER NOT NULL,
NomeRestaurante VARCHAR(MAX) NOT NULL,
Avaliacao INTEGER NOT NULL CHECK(Avaliacao >= 1 AND Avaliacao <= 5),
Descricao VARCHAR(MAX) NOT NULL,
Premium BIT NOT NULL,
PRIMARY KEY(IdUser),
FOREIGN KEY(IdUser) REFERENCES Utilizador(Id))

CREATE TABLE TipoDeComida(
Id INTEGER NOT NULL IDENTITY(1,1),
Tipo VARCHAR(MAX) NOT NULL,
PRIMARY KEY(Id))

CREATE TABLE RelTipo(
IdP INTEGER NOT NULL,
IdT INTEGER NOT NULL,
PRIMARY KEY(IdP,IdT),
FOREIGN KEY(IdP) REFERENCES Proprietario(IdUser),
FOREIGN KEY(IdT) REFERENCES TipoDeComida(Id))

CREATE TABLE Coordenadas(
IdProp INTEGER NOT NULL,
Clong FLOAT NOT NULL,
Clat FLOAT NOT NULL,
PRIMARY KEY(IdProp),
FOREIGN KEY(IdProp) REFERENCES Proprietario(IdUser))

CREATE TABLE FotografiasR(
IdProp INTEGER NOT NULL,
Foto VARBINARY(MAX) NOT NULL,
PRIMARY KEY(IdProp),
FOREIGN KEY(IdProp) REFERENCES Proprietario(IdUser))

CREATE TABLE Favoritos(
IdCliente INTEGER NOT NULL,
IdProp INTEGER NOT NULL,
DataAdd DATETIME2 NOT NULL,
PRIMARY KEY(IdCliente,IdProp,DataAdd),
FOREIGN KEY(IdCliente) REFERENCES Cliente(IdUser),
FOREIGN KEY(IdProp) REFERENCES Proprietario(IdUser))

CREATE TABLE Notificacoes(
Titulo VARCHAR(MAX) NOT NULL,
DataNotificacao DATETIME2 NOT NULL,
IdP INTEGER NOT NULL,
Mensagem VARCHAR(MAX) NOT NULL,
Visto BIT NOT NULL,
PRIMARY KEY(DataNotificacao,IdP),
FOREIGN KEY(IdP) REFERENCES Proprietario(IdUser))



CREATE TABLE Prato(
Id INTEGER NOT NULL IDENTITY(1,1),
Nome VARCHAR(MAX) NOT NULL,
Descricao VARCHAR(MAX) NOT NULL,
Tipo VARCHAR(MAX) NOT NULL,
Refeicao VARCHAR(MAX) NOT NULL,
DataR DATETIME2 NOT NULL,
Preco MONEY NOT NULL,
Fotografia VARBINARY(MAX) NOT NULL,
IdProp INTEGER NOT NULL,
PRIMARY KEY(Id),
FOREIGN KEY(IdProp) REFERENCES Proprietario(IdUser))


CREATE TABLE Avaliacao(
IdCliente INTEGER NOT NULL,
IdProp INTEGER NOT NULL,
DataAvaliacao DATETIME2 NOT NULL,
Comentario VARCHAR(MAX) NOT NULL,
Avaliacao FLOAT NOT NULL CHECK (Avaliacao >= 1 AND Avaliacao <= 5),
Autor VARCHAR(MAX),
PRIMARY KEY(IdCliente,IdProp,DataAvaliacao),
FOREIGN KEY(IdCliente) REFERENCES Cliente(IdUser),
FOREIGN KEY(IdProp) REFERENCES Proprietario(IdUser))

SELECT * FROM Avaliacao


CREATE TABLE Preferencias(
IdT INTEGER NOT NULL,
IdC INTEGER NOT NULL,
DataAdd DATETIME2 NOT NULL,
PRIMARY KEY(IdT,IdC,DataAdd),
FOREIGN KEY(IdT) REFERENCES TipoDeComida(Id),
FOREIGN KEY(IdC) REFERENCES Cliente(IdUser))


CREATE TABLE Administrador(
Id INTEGER NOT NULL IDENTITY(1,1),
Username VARCHAR(MAX) NOT NULL,
PW VARCHAR(MAX) NOT NULL,
PRIMARY KEY(Id))

CREATE TABLE Suspensao(
DataDeSuspensao DATETIME2 NOT NULL,
IdA INTEGER NOT NULL,
IdU INTEGER NOT NULL,
Tempo INTEGER NOT NULL,
Motivo VARCHAR(MAX) NOT NULL,
PRIMARY KEY(DataDeSuspensao,IdA,IdU),
FOREIGN KEY(IdA) REFERENCES Administrador(Id),
FOREIGN KEY(IdU) REFERENCES Utilizador(Id))

SELECT * FROM Prato


CREATE PROCEDURE stp_CreateUtilizador @usern VARCHAR(MAX), @name VARCHAR(MAX), @pw VARCHAR(MAX), @email VARCHAR(MAX), @state VARCHAR(MAX), @DA DATETIME2 --
AS

INSERT INTO Utilizador(Username,Nome,PW,Email,Estado,DataAsesao) VALUES (@usern,@name,@pw,@email,@state,@DA)

GO


CREATE PROCEDURE stp_GetUilizador @ID INTEGER --
AS

IF(@ID = 0 OR @ID IS NULL)
SELECT * FROM Utilizador
ELSE
SELECT * FROM Utilizador WHERE Id = @ID

GO

DELETE FROM Cliente WHERE IdUser >= 56
DELETE FROM Utilizador WHERE Id >= 56

CREATE PROCEDURE stp_UpdateUtilizador @what VARCHAR(MAX), @value VARCHAR(MAX), @id INTEGER --
AS

IF(@what = 'Username')
BEGIN

IF((SELECT COUNT(*) FROM Utilizador WHERE Username = @value) = 0)

UPDATE Utilizador SET Username = @value WHERE Id = @id

END

ELSE IF(@what = 'Nome')
UPDATE Utilizador SET Nome = @value WHERE Id = @id

ELSE IF (@what = 'Password')
BEGIN

IF((SELECT PW FROM Utilizador WHERE Id = @id) <> @value)
UPDATE Utilizador SET PW = @value WHERE Id = @id

END
ELSE IF(@what = 'Email')
UPDATE Utilizador SET Email = @value WHERE Id = @id

GO


CREATE PROCEDURE stp_SuspenderUtilizador @id INTEGER, @what VARCHAR(MAX) --
AS

IF((SELECT Estado FROM Utilizador WHERE Id = @id) <> 'Suspenso' AND (SELECT Estado FROM Utilizador WHERE Id = @id) <> 'Banido')
BEGIN

IF(@what = 'Suspender')
UPDATE Utilizador SET Estado = 'Suspenso' WHERE Id = @id

ELSE IF(@what = 'Banir')
UPDATE Utilizador SET Estado = 'Banido' WHERE Id = @id

END
ELSE

RETURN -1

GO



CREATE PROCEDURE stp_RecuperarUtilizador @id INTEGER --
AS

IF((SELECT Estado FROM Utilizador WHERE Id = @id) = 'Suspenso' OR (SELECT Estado FROM Utilizador WHERE Id = @id) = 'Banido')
UPDATE Utilizador SET Estado = 'Livre' WHERE Id = @id

ELSE

RETURN -1

GO



CREATE PROCEDURE stp_ValidarUtilizador @id INTEGER --
AS

UPDATE Utilizador SET Estado = 'Livre' WHERE Id = @id

GO

CREATE PROCEDURE stp_CreateCliente @idc INTEGER --
AS

INSERT INTO Cliente(IdUser) VALUES (@idc)

GO

CREATE PROCEDURE stp_GetCliente @idc INTEGER --
AS

IF(@idc = 0 OR @idc IS NULL)

SELECT * FROM Cliente

ELSE

SELECT * FROM Cliente WHERE IdUser = @idc

GO

CREATE PROCEDURE stp_DeleteCliente @Idc INTEGER --
AS

IF(@Idc <> 0 AND @Idc IS NOT NULL)

DELETE FROM Cliente WHERE IdUser = @Idc

ELSE

RETURN -1

GO


CREATE PROCEDURE stp_CreateProprietario @idp INTEGER, @NR VARCHAR(MAX), @ava FLOAT, @dsc VARCHAR(MAX), @pre BIT --
AS

INSERT Proprietario(IdUser,NomeRestaurante,Avaliacao,Descricao,Premium) VALUES (@idp,@NR,@ava,@dsc,@pre)

GO


CREATE PROCEDURE stp_GetProprietario @idp INTEGER, @name VARCHAR(MAX) --
AS

IF((@idp <> 0 AND @idp IS NOT NULL) AND (@name = '' OR @name IS NULL)) -- Pesquisa por Id

SELECT * FROM Proprietario WHERE IdUser = @idp

ELSE IF((@idp = 0 OR @idp IS NULL) AND (@name <> '' AND @name IS NOT NULL)) -- Pesquisa por nome

SELECT * FROM Proprietario WHERE NomeRestaurante = @name

ELSE IF((@idp = 0 OR @idp IS NULL) AND (@name = '' OR @name IS NULL))

SELECT * FROM Proprietario

ELSE

RETURN -1

GO



CREATE PROCEDURE stp_UpdateProprietario @what VARCHAR(MAX), @intev INTEGER, @Svalue VARCHAR(MAX), @IdP INTEGER --
AS

IF(@what = 'Nome')
BEGIN

IF(@Svalue <> '' AND @Svalue IS NOT NULL)

UPDATE Proprietario SET NomeRestaurante = @Svalue WHERE IdUser = @IdP

END

IF(@what = 'Avaliacao')
BEGIN

IF(@intev <> 0 AND @intev IS NOT NULL)

UPDATE Proprietario SET Avaliacao = @intev WHERE IdUser = @IdP

END

ELSE

RETURN -1

GO

CREATE PROCEDURE stp_GoPremium @idp INTEGER --
AS

UPDATE Proprietario SET Premium = 1 WHERE IdUser = @idp

GO

CREATE PROCEDURE stp_CreateTipoDeComida @type VARCHAR(MAX) --
AS

INSERT INTO TipoDeComida(Tipo) VALUES (@type)

GO

CREATE PROCEDURE stp_GetTipoDeComida @idt INTEGER --
AS

IF(@idt <> 0 AND @idt IS NOT NULL)

SELECT * FROM TipoDeComida WHERE Id = @idt

ELSE

SELECT * FROM TipoDeComida

GO



CREATE PROCEDURE stp_DeleteTipoDeComida @id INTEGER --
AS

DELETE FROM TipoDeComida WHERE Id = @id

GO

CREATE PROCEDURE stp_CreateRelTipo @idp INTEGER, @idt INTEGER --
AS

INSERT INTO RelTipo(IdP,IdT) VALUES (@idp,@idt)

GO


CREATE PROCEDURE stp_GetRelTipo @idp INTEGER, @idt INTEGER --
AS

IF((@idp = 0 OR @idp IS NULL) AND (@idt = 0 OR @idt IS NULL)) -- Tudo

SELECT * FROM RelTipo

ELSE IF((@idp <> 0 AND @idp IS NOT NULL) AND (@idt = 0 OR @idt IS NULL)) -- IdP

SELECT * FROM RelTipo WHERE IdP = @idp

ELSE IF((@idp = 0 OR @idp IS NULL) AND (@idt <> 0 AND @idt IS NOT NULL)) --IdT

SELECT * FROM RelTipo WHERE IdT = @idt

ELSE IF((@idp <> 0 AND @idp IS NOT NULL) AND (@idt <> 0 OR @idt IS NOT NULL)) -- Um em especifico

SELECT * FROM RelTipo WHERE IdP = @idp AND IdT = @idt

ELSE

RETURN -1

GO



CREATE PROCEDURE stp_DeleteRelTipo @idp INTEGER, @idt INTEGER --
AS

DELETE RelTipo WHERE IdP = @idp AND IdT = @idt

GO

CREATE PROCEDURE stp_CreateCoordenadas @Idp INTEGER, @long FLOAT, @lat FLOAT --
AS

INSERT INTO Coordenadas(IdProp,Clong,Clat) VALUES (@Idp,@long,@lat)

GO

CREATE PROCEDURE stp_GetCoordenadas @idp INTEGER --
AS

IF(@idp = 0 OR @idp IS NULL)

SELECT * FROM Coordenadas

ELSE

SELECT * FROM Coordenadas WHERE IdProp = @idp

GO

CREATE PROCEDURE stp_UpdateCoordenadas @idp INTEGER, @clong FLOAT, @clat FLOAT --
AS

IF((@clong = 0 OR @clong IS NULL) AND (@clat <> 0 AND @clat IS NOT NULL)) -- lat

UPDATE Coordenadas SET Clat = @clat WHERE IdProp = @idp

ELSE IF((@clong <> 0 AND @clong IS NOT NULL) AND (@clat = 0 OR @clat IS NULL)) -- log

UPDATE Coordenadas SET Clong = @clong WHERE IdProp = @idp

ELSE IF((@clong <> 0 AND @clong IS NOT NULL) AND (@clat <> 0 AND @clat IS NOT NULL)) -- os dois

UPDATE Coordenadas SET Clat = @clat, Clong = @clong WHERE IdProp = @idp

ELSE

RETURN -1


GO




CREATE PROCEDURE stp_DeleteCoordenadas @idp INTEGER --
AS

IF(@idp <> 0 AND @idp IS NOT NULL)

DELETE FROM Coordenadas WHERE IdProp = @idp

ELSE

RETURN -1

GO

CREATE PROCEDURE stp_CreateFotorafiasR @idp INTEGER, @foto VARBINARY(MAX) --
AS

IF((@idp <> 0) AND ( @idp IS NOT NULL) AND (@foto IS NOT NULL))

INSERT INTO FotografiasR(IdProp,Foto) VALUES (@idp,@foto)


ELSE

RETURN -1


GO


CREATE PROCEDURE stp_GetFotografiasR @idp INTEGER --
AS

IF(@idp <> 0 AND @idp IS NOT NULL)

SELECT * FROM FotografiasR WHERE IdProp = @idp

ELSE

SELECT * FROM FotografiasR

GO


CREATE PROCEDURE stp_DeleteFotografiaR @idp INTEGER --
AS

IF(@idp <> 0 AND @idp IS NOT NULL)

DELETE FROM FotografiasR WHERE IdProp = @idp

ELSE

RETURN -1

GO

CREATE PROCEDURE stp_CreateFavoritos @idc INTEGER, @idp INTEGER, @da DATETIME2 --
AS

IF((@idc <> 0 AND @idc IS NOT NULL) AND (@idp <> 0 AND @idp IS NOT NULL) AND (@da IS NOT NULL))

INSERT INTO Favoritos(IdCliente,IdProp,DataAdd) VALUES (@idc,@idp,@da)

ELSE 

RETURN -1

GO



CREATE PROCEDURE stp_GetFavoritos @idc INTEGER, @idp INTEGER --
AS

IF((@idp <> 0 OR @idp IS NOT NULL) AND (@idc = 0 OR @idc IS NULL)) -- IdP

SELECT * FROM Favoritos WHERE IdProp = @idp

ELSE IF((@idp = 0 OR @idp IS NULL) AND (@idc <> 0 AND @idc IS NOT NULL)) --IdT

SELECT * FROM Favoritos WHERE IdCliente = @idc

ELSE IF((@idp <> 0 AND @idp IS NOT NULL) AND (@idc <> 0 OR @idc IS NOT NULL)) -- Um em especifico

SELECT * FROM Favoritos WHERE IdProp = @idp AND IdCliente = @idc

ELSE

RETURN -1


GO




CREATE PROCEDURE stp_CreateNotificacao @title VARCHAR(MAX), @DN DATETIME2, @idp INTEGER, @message VARCHAR(MAX), --
@visto BIT
AS

INSERT INTO Notificacoes(Titulo,DataNotificacao,IdP,Mensagem,Visto) VALUES (@title,@DN,@idp,@message,@visto)

GO


CREATE PROCEDURE stp_GetNotificacoes @idc INTEGER, @idp INTEGER --
AS

SELECT * FROM Notificacoes 

GO



CREATE PROCEDURE stp_UpdateNotificacoes @idp INTEGER --
AS

UPDATE Notificacoes SET Visto = 1 where IdP = @idp

GO


CREATE PROCEDURE stp_CreatePrato @name VARCHAR(MAX), @dsc VARCHAR(MAX), @type VARCHAR(MAX), @ref VARCHAR(MAX), @dater DATETIME2, @price MONEY, @photo VARBINARY(MAX), @idp INTEGER --
AS

INSERT INTO Prato(Nome,Descricao,Tipo,Refeicao,DataR,Preco,Fotografia,IdProp) VALUES(@name,@dsc,@type,@ref,@dater,@price,@photo,@idp)


GO


CREATE PROCEDURE stp_GetPrato @id INTEGER, @type VARCHAR(MAX), @ref VARCHAR(MAX), @datar DATETIME2, @idp INTEGER, @what VARCHAR(MAX) --
AS

-- Pesquisar por id

IF(@what = 'IdSearch')
BEGIN
IF((@id IS NOT NULL) AND (@id <> 0))

SELECT * FROM Prato WHERE Id = @id

ELSE
RETURN -1

END

ELSE IF(@what = 'PratoDoDia')
BEGIN

IF((@datar IS NOT NULL) AND (@idp <> 0 AND @idp IS NOT NULL))

SELECT * FROM Prato WHERE DataR = @datar AND IdProp = @idp

ELSE

RETURN -1

END

ELSE IF(@what = 'Refeicao')
BEGIN

IF((@ref IS NOT NULL) AND (@ref <> '' )) 
SELECT * FROM Prato WHERE Refeicao = @ref

ELSE
RETURN -1

END

ELSE IF(@what = 'Tipo')
BEGIN

IF((@type IS NOT NULL) AND (@type <> '' ))

SELECT * FROM Prato WHERE Refeicao = @ref

ELSE 

RETURN -1

END

ELSE IF(@what = 'Proprietario')
BEGIN

IF((@idp <> 0 AND @idp IS NOT NULL))

SELECT * FROM Prato WHERE IdProp = @idp

ELSE

RETURN -1

END

GO

CREATE PROCEDURE stp_UpdatePrato @what VARCHAR(MAX), @DR DATETIME2, @price MONEY, @photo VARBINARY(MAX), @id INTEGER, @value VARCHAR(MAX) --
AS

IF(@what = 'Nome')

UPDATE Prato SET Nome = @value WHERE Id = @id

ELSE IF(@what = 'Descricao')

UPDATE Prato SET Descricao = @value WHERE Id = @id

ELSE IF(@what = 'Tipo')

UPDATE Prato SET Tipo = @value WHERE Id = @id

ELSE IF(@what = 'Refeicao')

UPDATE Prato SET Refeicao = @value WHERE Id = @id

ELSE IF(@what = 'DataR')

UPDATE Prato SET DataR = @DR WHERE Id = @id

ELSE IF(@what = 'Preco')

UPDATE Prato SET Preco = @price WHERE Id = @id

ELSE IF(@what = 'Fotografia')

UPDATE Prato SET Fotografia = @photo WHERE Id = @id

ELSE

RETURN -1

GO



CREATE PROCEDURE stp_CreateAvaliacao @idc INTEGER, @idp INTEGER, @da DATETIME2, @comment VARCHAR(MAX), @ava INTEGER,@author VARCHAR(MAX) --
AS

INSERT INTO Avaliacao(IdCliente,IdProp,DataAvaliacao,Comentario,Avaliacao,Autor) VALUES (@idc,@idp,@da,@comment,@ava,@author)

GO


CREATE PROCEDURE stp_GetAvaliacao @idc INTEGER, @idp INTEGER --
AS

IF((@idc = 0 OR @idc IS NULL) AND (@idp <> 0 AND @idp IS NOT NULL)) -- idp

SELECT * FROM Avaliacao WHERE IdProp = @idp

ELSE IF((@idc <> 0 AND @idc IS NOT NULL) AND (@idp = 0 OR @idp IS NULL)) --idc

SELECT * FROM Avaliacao WHERE IdCliente = @idc

ELSE IF((@idc <> 0 AND @idc IS NOT NULL) AND (@idp <> 0 OR @idp IS NOT NULL)) -- os dois

SELECT * FROM Avaliacao WHERE IdProp = @idp AND IdCliente = @idc

ELSE

SELECT * FROM Avaliacao

GO

CREATE PROCEDURE stp_DeleteAvaliacao @Idc INTEGER, @IdP INTEGER, @DA DATETIME2 --
AS

DELETE Avaliacao WHERE IdCliente = @Idc AND IdProp = @IdP AND DataAvaliacao = @DA

GO

CREATE PROCEDURE stp_CreatePreferencia @idt INTEGER, @idc INTEGER, @dadd DATETIME2 --
AS

INSERT INTO Preferencias(IdT,IdC,DataAdd) VALUES (@idt,@idc,@dadd)

GO

CREATE PROCEDURE stp_GetPreferencia @idt INTEGER, @idc INTEGER --
AS


IF((@idc = 0 OR @idc IS NULL) AND (@idt <> 0 AND @idt IS NOT NULL)) -- idt

SELECT * FROM Preferencias WHERE IdT = @idt

ELSE IF((@idc <> 0 AND @idc IS NOT NULL) AND (@idt = 0 OR @idt IS NULL)) --idc

SELECT * FROM Preferencias WHERE IdC = @idc

ELSE IF((@idc <> 0 AND @idc IS NOT NULL) AND (@idt <> 0 OR @idt IS NOT NULL)) -- os dois

SELECT * FROM Preferencias WHERE IdT = @idt AND IdC = @idc

ELSE

SELECT * FROM Preferencias

GO

DROP PROCEDURE stp_DeletePreferencia

CREATE PROCEDURE stp_DeletePreferencia @idt INTEGER, @idc INTEGER
AS

DELETE FROM Preferencias WHERE IdC = @idc AND IdT = @idt

GO

CREATE PROCEDURE stp_CreateAdministrador @usern VARCHAR(MAX), @pw VARCHAR(MAX) --
AS

IF((SELECT COUNT(*) FROM Administrador WHERE Username = @usern) = 0)

INSERT INTO Administrador(Username,PW) VALUES (@usern,@pw)

ELSE

RETURN -1

GO



CREATE PROCEDURE stp_GetAdministrador @usrn VARCHAR(MAX) --
AS

SELECT * FROM Administrador WHERE Username = @usrn

GO

CREATE PROCEDURE stp_CreateSuspensao @DS DATETIME2, @ida INTEGER, @idu INTEGER, @time INTEGER, @motive VARCHAR(MAX) --
AS

INSERT INTO Suspensao(DataDeSuspensao,IdA,IdU,Tempo,Motivo) VALUES (@DS,@ida,@idu,@time,@motive)

GO

CREATE PROCEDURE stp_GetSuspensao @ida INTEGER, @idu INTEGER
AS

IF((@ida = 0 OR @ida IS NULL) AND (@idu <> 0 AND @idu IS NOT NULL)) -- idu

SELECT * FROM Suspensao WHERE IdU = @idu

ELSE IF((@ida <> 0 AND @ida IS NOT NULL) AND (@idu = 0 OR @idu IS NULL)) --ida

SELECT * FROM Suspensao WHERE IdA = @ida

ELSE IF((@ida <> 0 AND @ida IS NOT NULL) AND (@idu <> 0 OR @idu IS NOT NULL)) -- os dois

SELECT * FROM Suspensao WHERE IdA = @ida AND IdU = @idu

ELSE

SELECT * FROM Suspensao

GO

SELECT * FROM Favoritos

CREATE PROCEDURE stp_DeleteSuspensao @ida INTEGER, @idu INTEGER, @DS DATETIME2
AS

DELETE FROM Suspensao WHERE IdA = @ida AND IdU = @idu AND DataDeSuspensao = @DS

GO

SELECT * FROM Favoritos


CREATE LOGIN ClientePD WITH PASSWORD = 'PD123'
CREATE LOGIN ProprietarioPD WITH PASSWORD = 'PD456'
CREATE LOGIN AdministradorPD WITH PASSWORD = 'PD789'
CREATE LOGIN AnonimoPD WITH PASSWORD = 'PD000'

CREATE USER Cliente FROM LOGIN ClientePD

CREATE USER Proprietario FROM LOGIN ProprietarioPD

CREATE USER Administrador FROM LOGIN AdministradorPD

CREATE USER Anonimo FROM LOGIN AnonimoPD

-- Premissões

--Anonimo

GRANT INSERT ON Utilizador TO Anonimo
GRANT INSERT ON Cliente TO Anonimo
GRANT INSERT ON Proprietario TO Anonimo


GRANT EXECUTE ON stp_CreateUtilizador TO  Anonimo
GRANT EXECUTE ON stp_CreateCliente TO Anonimo
GRANT EXECUTE ON stp_CreateProprietario TO Anonimo

-- Cliente


GRANT SELECT ON Utilizador TO Cliente
GRANT UPDATE ON Utilizador TO Cliente
GRANT INSERT ON Favoritos TO Cliente
GRANT SELECT ON Favoritos TO Cliente
GRANT SELECT ON Notificacoes TO Cliente
GRANT UPDATE ON Notificacoes TO Cliente
GRANT SELECT ON Prato TO Cliente
GRANT INSERT ON Avaliacao TO Cliente
GRANT SELECT ON Avaliacao TO Cliente
GRANT DELETE ON Avaliacao TO Cliente
GRANT INSERT ON Preferencias TO Cliente
GRANT SELECT ON Preferencias TO Cliente
GRANT DELETE ON Preferencias TO Cliente
GRANT SELECT ON Suspensao TO Cliente



GRANT EXECUTE ON stp_GetUilizador TO Cliente
GRANT EXECUTE ON stp_UpdateUtilizador TO Cliente
GRANT EXECUTE ON stp_CreateFavoritos TO Cliente
GRANT EXECUTE ON stp_GetFavoritos TO Cliente
GRANT EXECUTE ON stp_GetNotificacoes TO Cliente
GRANT EXECUTE ON stp_UpdateNotificacoes TO Cliente
GRANT EXECUTE ON stp_GetPrato TO Cliente
GRANT EXECUTE ON stp_CreateAvaliacao TO Cliente
GRANT EXECUTE ON stp_GetAvaliacao TO Cliente
GRANT EXECUTE ON stp_DeleteAvaliacao TO Cliente
GRANT EXECUTE ON stp_CreatePreferencia TO Cliente
GRANT EXECUTE ON stp_GetPreferencia TO Cliente
GRANT EXECUTE ON stp_DeletePreferencia TO Cliente
GRANT EXECUTE ON stp_GetSuspensao TO Cliente

SELECT * FROM Notificacoes

-- Proprietario

GRANT SELECT ON Proprietario TO Proprietario
GRANT UPDATE ON Proprietario TO Proprietario
GRANT SELECT ON TipoDeComida TO Proprietario
GRANT INSERT ON RelTipo TO Proprietario
GRANT SELECT ON RelTipo TO Proprietario
GRANT DELETE ON RelTipo TO Proprietario
GRANT INSERT ON Coordenadas TO Proprietario
GRANT SELECT ON Coordenadas TO Proprietario
GRANT UPDATE ON Coordenadas TO Proprietario
GRANT DELETE ON Coordenadas TO Proprietario
GRANT INSERT ON FotografiasR TO Proprietario
GRANT SELECT ON FotografiasR TO Proprietario
GRANT DELETE ON FotografiasR TO Proprietario
GRANT SELECT ON Favoritos TO Proprietario
GRANT INSERT ON Notificacoes TO Proprietario
GRANT SELECT ON Notificacoes TO Proprietario
GRANT INSERT ON Prato TO Proprietario
GRANT SELECT ON Prato TO Proprietario
GRANT UPDATE ON Prato TO Proprietario
GRANT SELECT ON Avaliacao TO Proprietario
GRANT SELECT ON Suspensao TO Proprietario
GRANT SELECT ON Utilizador TO Proprietario
GRANT UPDATE ON Utilizador TO Proprietario



GRANT EXECUTE ON stp_GetProprietario TO Proprietario
GRANT EXECUTE ON stp_UpdateProprietario TO Proprietario
GRANT EXECUTE ON stp_GetTipoDeComida TO Proprietario
GRANT EXECUTE ON stp_CreateRelTipo TO Proprietario
GRANT EXECUTE ON stp_GetRelTipo TO Proprietario
GRANT EXECUTE ON stp_DeleteRelTipo TO Proprietario
GRANT EXECUTE ON stp_CreateCoordenadas TO Proprietario
GRANT EXECUTE ON stp_GetCoordenadas TO Proprietario
GRANT EXECUTE ON stp_UpdateCoordenadas TO Proprietario
GRANT EXECUTE ON stp_DeleteCoordenadas TO Proprietario
GRANT EXECUTE ON stp_CreateFotorafiasR TO Proprietario
GRANT EXECUTE ON stp_GetFotografiasR TO Proprietario
GRANT EXECUTE ON stp_DeleteFotografiaR TO Proprietario
GRANT EXECUTE ON stp_GetFavoritos TO Proprietario
GRANT EXECUTE ON stp_CreateNotificacao TO Proprietario
GRANT EXECUTE ON stp_GetNotificacoes TO Proprietario
GRANT EXECUTE ON stp_CreatePrato TO Proprietario
GRANT EXECUTE ON stp_GetPrato TO Proprietario
GRANT EXECUTE ON stp_UpdatePrato TO Proprietario
GRANT EXECUTE ON stp_GetAvaliacao TO Proprietario
GRANT EXECUTE ON stp_GetSuspensao TO Proprietario
GRANT EXECUTE ON stp_GetUilizador TO Proprietario
GRANT EXECUTE ON stp_UpdateUtilizador TO Proprietario
GRANT EXECUTE ON stp_GoPremium TO Proprietario


-- Administrador


GRANT SELECT ON Utilizador TO Administrador
GRANT UPDATE ON Utilizador TO Administrador
GRANT SELECT ON Proprietario TO Administrador
GRANT SELECT ON Cliente TO Administrador
GRANT INSERT ON TipoDeComida TO Administrador
GRANT SELECT ON TipoDeComida TO Administrador
GRANT DELETE ON TipoDeComida TO Administrador
GRANT SELECT ON RelTipo TO Administrador
GRANT DELETE ON RelTipo TO Administrador
GRANT SELECT ON FotografiasR TO Administrador
GRANT SELECT ON Notificacoes TO Administrador
GRANT SELECT ON Prato TO Administrador
GRANT SELECT ON Avaliacao TO Administrador
GRANT INSERT ON Administrador TO Administrador
GRANT SELECT ON Administrador TO Administrador
GRANT DELETE ON Administrador TO Administrador



GRANT EXECUTE ON stp_GetUilizador TO Administrador
GRANT EXECUTE ON stp_SuspenderUtilizador TO Administrador
GRANT EXECUTE ON stp_RecuperarUtilizador TO Administrador
GRANT EXECUTE ON stp_ValidarUtilizador TO Administrador
GRANT EXECUTE ON stp_GetProprietario TO Administrador
GRANT EXECUTE ON stp_GetCliente TO Administrador
GRANT EXECUTE ON stp_CreateTipoDeComida TO Administrador
GRANT EXECUTE ON stp_GetTipoDeComida TO Administrador
GRANT EXECUTE ON stp_DeleteTipoDeComida TO Administrador
GRANT EXECUTE ON stp_GetRelTipo TO Administrador
GRANT EXECUTE ON stp_DeleteRelTipo TO Administrador
GRANT EXECUTE ON stp_GetFotografiasR TO Administrador
GRANT EXECUTE ON stp_GetNotificacoes TO Administrador
GRANT EXECUTE ON stp_GetPrato TO Administrador
GRANT EXECUTE ON stp_GetAvaliacao TO Administrador
GRANT EXECUTE ON stp_CreateAdministrador TO Administrador
GRANT EXECUTE ON stp_GetAdministrador TO Administrador
GRANT EXECUTE ON stp_CreateSuspensao TO Administrador
GRANT EXECUTE ON stp_GetSuspensao TO Administrador
GRANT EXECUTE ON stp_DeleteSuspensao TO Administrador


INSERT INTO Utilizador(Username,Nome,PW,Email,Estado,DataAsesao) VALUES ('TESTE','TESTE NOME','123','djk','Livre', GETDATE())

INSERT INTO TipoDeComida(Tipo) values ('Portuguesa')
INSERT INTO TipoDeComida(Tipo) values ('Japonesa')
INSERT INTO TipoDeComida(Tipo) values ('Italiana')
INSERT INTO TipoDeComida(Tipo) values ('Fast Food')

SELECT * FROM TipoDeComida


CREATE PROCEDURE stp_DeletePrato @id INTEGER
AS

DELETE FROM Prato WHERE Id = @id

GO


GRANT DELETE ON Prato TO Proprietario
GRANT EXECUTE ON stp_DeletePrato TO Proprietario


INSERT INTO Administrador(Username,PW) VALUES ('admin','12345')

SELECT * FROM Coordenadas


CREATE PROCEDURE stp_DeleteFavorito @idp INTEGER, @idc INTEGER
AS

DELETE Favoritos WHERE IdProp = @idp AND IdCliente = @idc

GO

GRANT DELETE ON Favoritos TO Cliente
GRANT EXECUTE ON stp_DeleteFavorito TO Cliente

SELECT * FROM Favoritos

SELECT * FROM Prato
