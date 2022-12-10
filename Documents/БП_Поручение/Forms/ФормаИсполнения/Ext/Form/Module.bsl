﻿&НаСервере
Функция ВыполненоСервер(ПроверкаУспешно, ВставлятьКомм)
	
	НачатьТранзакцию();
	БП = Объект.Заявка.ПолучитьОбъект();
	СтруктураПоиска = Новый Структура("Исполнитель", ПараметрыСеанса.ТекущийПользователь);
	НайдденныеСтроки = БП.СписокИсполнителей.НайтиСтроки(СтруктураПоиска);
	Для каждого ТекСтрока Из НайдденныеСтроки Цикл
		ТекСтрока.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		ТекСтрока.Комментарии = Комментарий;
		ТекСтрока.Приложение = ПрикрепитьДокумент;	
		ТекСтрока.Исполнено = Истина;
		ТекСтрока.ДатаВыполнения = ТекущаяДата();
	КонецЦикла;
	
	СтруктураПоиска = Новый Структура("Исполнено", Ложь);
	Если НЕ БП.СписокИсполнителей.НайтиСтроки(СтруктураПоиска).Количество() И НЕ Бп.КонтрольИсполнения Тогда
		БП.Завершен = Истина;
		БП.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		БП.Записать();
	КонецЕсли;
	
	БПСервер.ВыполнитьЗадачу(Объект.Ссылка,0, "", Комментарий);
	
	
	
	Если Бп.КонтрольИсполнения И ПараметрыСеанса.ТекущийПользователь <> БП.Автор Тогда
		СоздатьЗадачуКонтроля(БП.Ссылка);	
	КонецЕсли;
	ЗафиксироватьТранзакцию();
	
	Возврат Истина;
КонецФункции

&НаСервере
Процедура СоздатьЗадачуКонтроля(БП)
	
		Задача = Задачи.Задача.СоздатьЭлемент();		
		Задача.Заявка = БП;
		Задача.Дата = ТекущаяДата();
		Задача.Наименование = "Проверить выполнение задания:" + Строка(ПараметрыСеанса.ТекущийПользователь);
		
		//Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
		//Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
		
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Объект.Описание;
		Задача.Исполнитель = БП.Автор;
		Задача.Записать();

	
	
КонецПроцедуры

&НаКлиенте
Процедура Выполнено(Команда)
	Если НЕ ЗначениеЗаполнено(Комментарий) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Заполните комментарий к исполнению.";
		Сообщение.Поле = "Комментарий";
		Сообщение.Сообщить(); 
	   	Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СрокИсполнения) И ТекущаяДата() > СрокИсполнения И НЕ ЗначениеЗаполнено(ПричинаПросрочки) И Объект.ВРаботе Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Заполните причину просрочки выполнения задания.";
		Сообщение.Поле = "ПричинаПросрочки";
		Сообщение.Сообщить(); 
		Возврат;
	КонецЕсли;
	
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			//Результат = ВыполненоСервер(1, 1);
			Результат = БПСервер.ВыполнитьКомандуЗадачиБП(Объект.Ссылка, "Выполнено", ПолучитьСтруктуруРеквизитовФормы(), Истина);
			ОповеститьОбИзменении(Объект.Заявка);
			Оповестить("ОбновитьСписокЗадач");
			Если Результат Тогда
				Закрыть();			
			КонецЕсли;
		КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаНажатие(Элемент, СтандартнаяОбработка)
	
	Если НЕ Объект.Заявка.Пустая() Тогда
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.Д_СлужебнаяЗаписка") Тогда
			СтандартнаяОбработка = Ложь;
			БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(Документ, "");
		ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.Д_ЗаявкаНаОплату") Тогда
			СтандартнаяОбработка = Ложь;
			БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(Документ, "");
		КонецЕсли;
		
		
	КонецЕсли;
	
	
	
	
	
КонецПроцедуры

&НаСервере
Процедура ПечатьЗаявка(ТабДок, ПараметрКоманды)
	Документы.Д_ЗаявкаНаОплату.Печать(ТабДок, ПараметрКоманды);
КонецПроцедуры


&НаСервере
Процедура ПечатьСЗ(ТабДок, ПараметрКоманды)
	Документы.Д_СлужебнаяЗаписка.Печать(ТабДок, ПараметрКоманды);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытьФормуЗадачи" Тогда
		ЭтаФорма.Закрыть();	
	//ИначеЕсли ИмяСобытия = "ПрикрепленныеФайлы" Тогда	
	//	ОбщегоНазначенияКлиентСервер.ОбновитьКоличествоПрикрепленныхФайлов(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Объект.Заявка = Неопределено Тогда
		БП = Объект.Заявка.ПолучитьОбъект();
		Если Объект.Исполнитель = БП.Автор Тогда
			ТекИсполнитель = Объект.Автор;
		Иначе
			ТекИсполнитель = Объект.Исполнитель;
		КонецЕсли;
		СтруктураПоиска = Новый Структура("Исполнитель", ПараметрыСеанса.ТекущийПользователь);
		НайденныеСтроки = БП.СписокИсполнителей.НайтиСтроки(СтруктураПоиска);
		Для каждого ТекСтрока Из НайденныеСтроки Цикл
			Комментарий = ТекСтрока.Комментарии;
			ПрикрепитьДокумент = ТекСтрока.Приложение;	
			ПричинаВозврата = ТекСтрока.ПричинаВозврата;
			СрокИсполнения = ТекСтрока.СрокИсполнения;
		КонецЦикла;	
		Документ = БП.Документ;
		ОтИмени = БП.ОтИмени;
		Тема = БП.Тема; 
		
		//ВложенныеФайлы = БП.ПрикрепленныйДокумент;
	КонецЕсли;
	Если ПричинаВозврата = "" Тогда
		Элементы.ПричинаВозврата.Видимость = Ложь;
	Иначе
		Элементы.ПричинаВозврата.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
	КонецЕсли;
	Если ЗначениеЗаполнено(СрокИсполнения) И ТекущаяДата() > СрокИсполнения И Объект.ВРаботе Тогда
		Элементы.ПричинаПросрочки.Видимость = Истина;
	Иначе
		Элементы.ПричинаПросрочки.Видимость = Ложь;
	КонецЕсли;
	
	
	ТекВидимостьКнопкИВыполнения = Объект.ВРаботе;
	Если Объект.Автор = БюджетныйНаСервере.ПолучитьПользователя() И НЕ Объект.Исполнитель = БюджетныйНаСервере.ПолучитьПользователя() Тогда
		 ТекВидимостьКнопкИВыполнения = Ложь;
	КонецЕсли;
	//Элементы.ЗаявкаСогласована.Видимость = ТекВидимостьКнопкИВыполнения;
	Если НЕ ТекВидимостьКнопкИВыполнения Тогда
		Элементы.Группа1.ОтображатьЗаголовок = Ложь;
		Элементы.ПрикрепитьДокумент.Видимость = Ложь;
		Элементы.Комментарий.Заголовок = "Комментарий к взятию в работу";
		Элементы.Комментарий.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	//Элементы.ЗадачаЗадачаВзятьЗадачуВРаботу.Видимость = НЕ Объект.ВРаботе;
	Если Объект.ВРаботе Тогда
		Элементы.ЗадачаЗадачаВзятьЗадачуВРаботу.Заголовок = "Отложить выполнение";
		Элементы.ЗадачаЗадачаВзятьЗадачуВРаботу.ЦветТекста = Новый Цвет(255,0,0);
	Иначе
		Элементы.Группа3.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	КонецЕсли;
	//сабОбщегоНазначения.ОбновитьКоличествоПрикрепленныхФайловСервер(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруРеквизитовФормы()
	
	Результат = новый Структура();
	
	Результат.Вставить("Комментарий", Комментарий);
	Результат.Вставить("ПричинаПросрочки", ПричинаПросрочки);
	Результат.Вставить("ПрикрепитьДокумент", ПрикрепитьДокумент);
	
	Возврат Результат;
	
КонецФункции




















