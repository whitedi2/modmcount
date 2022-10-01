﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТекЗадачи = ПолучитьТекЗадачи(ПараметрКоманды);
	
	Если НЕ ТекЗадачи.Количество() Тогда
		Предупреждение("Не найдены текущие задачи по документам!");
		Возврат;
	КонецЕсли;
	
	
	
	Если НЕ БюджетныйНаСервере.РольАдминаДоступнаСервер() Тогда
		Для каждого ТекЗаявка Из ТекЗадачи Цикл
			Если НЕ БПСервер.ТекПользовательИсполнительЗадачи(ТекЗаявка) Тогда
				Предупреждение("Вы не являетесь исполнителем по данной задаче! Перенаправление задачи невозможно!");
				Возврат;
			КонецЕсли;	
		КонецЦикла; 
	КонецЕсли;
	

	
	
	СтруктураПараметров = ОткрытьФормуМодально("Задача.Задача.Форма.ФормаПеренаправления");
	
	Если Не СтруктураПараметров = Неопределено Тогда
		Если НЕ ТипЗнч(ТекЗадачи) = Тип("Массив") Тогда
			МассивЗадач = Новый Массив;
			МассивЗадач.Добавить(ТекЗадачи);
		Иначе
			МассивЗадач = ТекЗадачи;
		КонецЕсли;
		Отказ = Ложь;
		БПСервер.ПеренаправитьЗадачиСервер(МассивЗадач, СтруктураПараметров, Отказ);
		//Если НЕ ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Задача.Задача.Форма.СписокМоихЗадач" И НЕ ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Задача.Задача.Форма.СписокМоихЗадач7"  И НЕ ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Задача.Задача.Форма.ФормаУниверсальная" Тогда
		//	ПараметрыВыполненияКоманды.Источник.Закрыть();	
		//КонецЕсли;
		
		Если Не Отказ Тогда
			ОповеститьОбИзменении(МассивЗадач[0]);
			Оповестить("ОбновитьСписокОбращений");
			Оповестить("ОбновитьСписокЗадач");
			Для Каждого ТекЗадача Из ТекЗадачи Цикл
				БПСервер.ЗаписатьДействиеПользователяВЛог(ТекЗадача, "Перенаправить");
			КонецЦикла;
		Иначе
			Предупреждение("Невозможно перенаправить задачу.");
		КонецЕсли;
	КонецЕсли;
	
	
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Задача.Задача.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

Функция ПолучитьТекЗадачи(ПараметрКоманды)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Задача.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.Д_ОбращенияВТехПоддержку КАК Д_ОбращенияВТехПоддержку
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.Задача КАК Задача
	               |		ПО (Задача.Выполнена = ЛОЖЬ)
	               |			И (Задача.ПометкаУдаления = ЛОЖЬ)
	               |			И Д_ОбращенияВТехПоддержку.Ссылка = Задача.Заявка
	               |ГДЕ
	               |	Д_ОбращенияВТехПоддержку.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", ПараметрКоманды);
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции // ()

