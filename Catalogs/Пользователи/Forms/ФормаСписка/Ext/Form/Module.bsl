﻿
&НаСервере
Процедура УУ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	УстановитьПривилегированныйРежим(Истина);
	СеансыИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();
	ТекПользователиМассив = Новый Массив;
	ВсегоOnLine = 0;
	ВсегоOnLineСеансов = 0;
	Для Каждого СеансИБ Из СеансыИнформационнойБазы Цикл
		Если ТекПользователиМассив.Найти(СеансИБ.Пользователь.Имя) = Неопределено Тогда
			ТекПользователиМассив.Добавить(СеансИБ.Пользователь.Имя);
			ВсегоOnLine = ВсегоOnLine + 1;
		КонецЕсли;
		ВсегоOnLineСеансов = ВсегоOnLineСеансов + 1;
	КонецЦикла;
	ПользователиСписок.Параметры.УстановитьЗначениеПараметра("ТекДата", ТекущаяДата());
	ПользователиСписок.Параметры.УстановитьЗначениеПараметра("МассивАктивных", ТекПользователиМассив);
	
	Элемент = Элементы.Добавить("ПользователиСписокДолжность", Тип("ПолеФормы"), Элементы.ПользователиСписок);
	Элемент.ПутьКДанным = "ПользователиСписок.Должность";
	Элемент.Заголовок = "Должность";
	
	Элемент = Элементы.Добавить("ПользователиСписокТекущийСтатус", Тип("ПолеФормы"), Элементы.ПользователиСписок);
	Элемент.ПутьКДанным = "ПользователиСписок.ТекущийСтатус";
	Элемент.Заголовок = "Текущий статус";
	
	Элемент = Элементы.Добавить("ПользователиСписокРуководитель", Тип("ПолеФормы"), Элементы.ПользователиСписок);
	Элемент.ПутьКДанным = "ПользователиСписок.Руководитель";
	Элемент.Заголовок = "Руководитель";
	
	Элемент = Элементы.Добавить("ПользователиСписокДоступныеПредприятия", Тип("ПолеФормы"), Элементы.ПользователиСписок);
	Элемент.ПутьКДанным = "ПользователиСписок.ДоступныеПредприятия";
	Элемент.Заголовок = "Доступные предприятия";
	
	Группа = Элементы.Добавить(
		"ГруппаШапка",
		Тип("ГруппаФормы"),
		ЭтаФорма);
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Заголовок = "";
	
	ПолеНадписи = Элементы.Добавить("ФормаВсегоOnLine", Тип("ПолеФормы"), Группа);
	ПолеНадписи.Вид = ВидПоляФормы.ПолеНадписи;
	ПолеНадписи.ПутьКДанным = "ВсегоOnLine";
	ПолеНадписи.Заголовок = "Всего OnLine";
	
	ПолеНадписи = Элементы.Добавить("ФормаВсегоOnLineСеансов", Тип("ПолеФормы"), Группа);
	ПолеНадписи.Вид = ВидПоляФормы.ПолеНадписи;
	ПолеНадписи.ПутьКДанным = "ВсегоOnLineСеансов";
	ПолеНадписи.Заголовок = "Всего OnLine сеансов";
	
	Элементы.ПользователиСписок.Шапка = Истина;
	Элементы.ПользователиСписок.ПутьКДаннымКартинкиСтроки = "ПользователиСписок.ИдентификаторКартинки";
	Элементы.ПользователиСписок.КартинкаСтрок = БиблиотекаКартинок.ПиктограммыПользователей;
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры
