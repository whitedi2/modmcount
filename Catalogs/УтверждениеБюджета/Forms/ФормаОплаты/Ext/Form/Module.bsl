﻿&НаСервере
Процедура ВыполненоСервер(ПроверкаУспешно, ВставлятьКомм)
	
	НачатьТранзакцию();
	
	//добавляем комментарии в историю переписки
	БП = Объект.БизнесПроцесс.ПолучитьОбъект();
	Объект.Комментарии = Строка(ТекущаяДата()) + ": " + ПараметрыСеанса.ТекущийПользователь + ?(ПроверкаУспешно, "", " не") + " ознакомился с утверждением бюджета:
		|" + Комментарий;
	БП.Комментарии = БП.Комментарии + "
	|" + Объект.Комментарии;
	БП.СогласованоДействие4 = ПроверкаУспешно;
	
	Если НЕ ВставлятьКомм Тогда // если заявка согласована или нет
		СтруктураПоиска = Новый Структура("Пользователь", ПараметрыСеанса.ТекущийПользователь);
		МассивСтрок = БП.ДопСогласование.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрок.Количество() Тогда //если отменяет один из рецензентов
			Для каждого ТекСтрока Из МассивСтрок Цикл
				ТекСтрока.Пройден = 0;
				ТекСтрока.Согласовано = 0;
				ТекСтрока.ДатаВыполнения = ТекущаяДата();
				ТекСтрока.Комментарии = "Отменил(а) бюджет. " + Строка(Комментарий);
				Комментарий = "Отменил(а) бюджет. " +  Комментарий;
				ТекСтрока.Пользователь = ПараметрыСеанса.ТекущийПользователь;
			КонецЦикла;
		Иначе //если отменяет не рецензент
			Комментарий = "Отменил(а) бюджет. " +  Комментарий;
		КонецЕсли;
	КонецЕсли;
	
	Если БП.ХранилищеТабДока.Получить() = Неопределено Тогда
	
		// 27.09.2012 создание таб дока и помещение его в хранилище
		ТабДок = Новый ТабличныйДокумент;
		Документы.Д_Бюджет.ПечатьПоУмолчанию(ТабДок, БП.Заявка, БП.ТипБюджета);
	
		АдресВХ = ПоместитьВоВременноеХранилище(ТабДок, Новый УникальныйИдентификатор());
		РеквизитСХранилищем = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресВХ));
		БП.ХранилищеТабДока = РеквизитСХранилищем;
		
	КонецЕсли;
		
	БП.Записать();
	
	БПСервер.ВыполнитьЗадачу(Объект.Ссылка, 0, ?(ПроверкаУспешно, "Да.", "Нет."), Комментарий);
	
	Если Ложь Тогда //нужно исправить!!!
		
		БПСервер.СоздатьОповещение(Справочники.Пользователи.ПустаяСсылка(), Строка(БП.ТипБюджета) + " предприятия " + Строка(Объект.Заявка.Предприятие) + " утвержден."
		, "Оповещение: утвержден " + Строка(БП.ТипБюджета) + "(" + Строка(Объект.Заявка.Предприятие) + ")", Объект.БизнесПроцесс);	
		
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкаСогласована(Команда)
	
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
	    Возврат;	
	КонецЕсли;
	
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			ВыполненоСервер(1, 1);
			ОповеститьОбИзменении(Объект.Ссылка);
			Оповестить("ОбновитьСписокЗадач");
			Закрыть();
		КонецЕсли;
	//КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БП = Объект.БизнесПроцесс.ПолучитьОбъект();
	ТЗ = БП.ДопСогласование.Выгрузить();
	ДопСогласование.Загрузить(ТЗ);
	
	
	Если НЕ БПСервер.ТекПользовательИсполнительЗадачи(Объект.Ссылка) Тогда
		Элементы.ЗаявкаСогласована.Видимость = 0;
		Элементы.НаДоработку.Видимость = 0;
	Иначе
		Элементы.ОтменаОплаты.Видимость = 0;
	КонецЕсли;
	
	Объект.Комментарии = Объект.БизнесПроцесс.ПолучитьОбъект().Комментарии;
КонецПроцедуры


&НаКлиенте
Процедура НаДоработку(Команда)
	
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
	    Возврат;	
	КонецЕсли;
	
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			ВыполненоСервер(0, 1);
			ОповеститьОбИзменении(Объект.Ссылка);
			Оповестить("ОбновитьСписокЗадач");
			Закрыть();
		КонецЕсли;
	//КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ОтменаЗаявки(Команда)
	
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
	    Возврат;	
	КонецЕсли;
	
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			ВыполненоСервер(0, 0);
			ОповеститьОбИзменении(Объект.Ссылка);
			Оповестить("ОбновитьСписокЗадач");
			Закрыть();
		КонецЕсли;
	//КонецЕсли;

КонецПроцедуры
 
&НаКлиенте
Процедура ЗаявкаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТабДок = Новый ТабличныйДокумент;
	
	ТипБюджета = БюджетныйНаСервере.ВернутьРеквизит(Объект.БизнесПроцесс, "ТипБюджета");
	Печать(ТабДок, Объект.БизнесПроцесс, ТипБюджета);
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.ОтображатьГруппировки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("Документ.Д_Бюджет.Форма.ФормаПечатиЗатрат");
	ФормаПечати.ТабДок = ТабДок;
	ФормаПечати.Открыть();
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды, ТипБюджета)	
	Документы.Д_Бюджет.Печать(ТабДок, ПараметрКоманды, ТипБюджета);//ПараметрКоманды);	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	сабОбщегоНазначенияКлиент.ОбновитьКоличествоПрикрепленныхФайлов(ЭтаФорма);
	ЭтаФорма.ЗаблокироватьДанныеФормыДляРедактирования();
КонецПроцедуры


