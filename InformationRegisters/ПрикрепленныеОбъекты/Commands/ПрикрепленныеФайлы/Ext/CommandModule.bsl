﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Владелец", ПараметрКоманды);
	//
	//Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.БП_Оповещение") или ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.БП_Поручение") Тогда
	//	//Параметр ВидимыеАвторы добавляет отбор по авторам в динамическом списке файлов: пользователь видит только файлы автора и свои. Автор видит все
	//	Автор = БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Автор");
	//	ТекПользователь = БюджетныйНаСервере.ПолучитьПользователя();
	//	Если Автор <> ТекПользователь тогда
	//		ВидимыеАвторыФайлов = Новый Массив;
	//		ВидимыеАвторыФайлов.Добавить(Автор);     
	//		ВидимыеАвторыФайлов.Добавить(ТекПользователь);
	//		ПараметрыФормы.Вставить("ВидимыеАвторыФайлов", ВидимыеАвторыФайлов);
	//	КонецЕсли;
	//Иначе
	//	
	//КонецЕсли;
	//
	//ОткрытьФорму("Справочник.Файлы.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
	ТекФорма = ПолучитьФорму("РегистрСведений.ПрикрепленныеОбъекты.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
		
	ТекФорма.Открыть();
КонецПроцедуры
