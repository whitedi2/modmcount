﻿
&НаСервере
&Вместо("ОбновитьСписокВыбранныхНаСервере")
Процедура УУ_ОбновитьСписокВыбранныхНаСервере()
	
	Список.КомпоновщикНастроек.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
	
	//++д1 20.09.21 ошибка сортировки после обновления платформы
	Список.КомпоновщикНастроек.Настройки.Порядок.Элементы.Очистить();
	//---
	
	Структура = Список.КомпоновщикНастроек.Настройки.Структура;
	Структура.Очистить();
	ГруппировкаКомпоновкиДанных = Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаКомпоновкиДанных.Использование = Истина;
	
	Выбор = Список.КомпоновщикНастроек.Настройки.Выбор;
	ПолеВыбора = Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	ПолеВыбора.Использование = Истина;
	
	ОбновитьКоличествоВыбранныхСервер();
	
КонецПроцедуры
